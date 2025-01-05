
obj/user/icode:     file format elf64-x86-64


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
  80001e:	e8 cd 01 00 00       	call   8001f0 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 81 ec 18 02 00 00 	sub    $0x218,%rsp
    int fd, n, r;
    char buf[512 + 1];

    binaryname = "icode";
  800039:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800040:	00 00 00 
  800043:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80004a:	00 00 00 

    cprintf("icode startup\n");
  80004d:	48 bf 06 40 80 00 00 	movabs $0x804006,%rdi
  800054:	00 00 00 
  800057:	b8 00 00 00 00       	mov    $0x0,%eax
  80005c:	48 bb 25 04 80 00 00 	movabs $0x800425,%rbx
  800063:	00 00 00 
  800066:	ff d3                	call   *%rbx

    cprintf("icode: open /motd\n");
  800068:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  80006f:	00 00 00 
  800072:	b8 00 00 00 00       	mov    $0x0,%eax
  800077:	ff d3                	call   *%rbx
    if ((fd = open("/motd", O_RDONLY)) < 0)
  800079:	be 00 00 00 00       	mov    $0x0,%esi
  80007e:	48 bf 28 40 80 00 00 	movabs $0x804028,%rdi
  800085:	00 00 00 
  800088:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  80008f:	00 00 00 
  800092:	ff d0                	call   *%rax
  800094:	89 c3                	mov    %eax,%ebx
  800096:	85 c0                	test   %eax,%eax
  800098:	78 31                	js     8000cb <umain+0xa6>
        panic("icode: open /motd: %i", fd);

    cprintf("icode: read /motd\n");
  80009a:	48 bf 51 40 80 00 00 	movabs $0x804051,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	48 ba 25 04 80 00 00 	movabs $0x800425,%rdx
  8000b0:	00 00 00 
  8000b3:	ff d2                	call   *%rdx
    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
  8000b5:	49 bc cc 1a 80 00 00 	movabs $0x801acc,%r12
  8000bc:	00 00 00 
        sys_cputs(buf, n);
  8000bf:	49 bd ce 11 80 00 00 	movabs $0x8011ce,%r13
  8000c6:	00 00 00 
    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
  8000c9:	eb 3a                	jmp    800105 <umain+0xe0>
        panic("icode: open /motd: %i", fd);
  8000cb:	89 c1                	mov    %eax,%ecx
  8000cd:	48 ba 2e 40 80 00 00 	movabs $0x80402e,%rdx
  8000d4:	00 00 00 
  8000d7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000dc:	48 bf 44 40 80 00 00 	movabs $0x804044,%rdi
  8000e3:	00 00 00 
  8000e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000eb:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  8000f2:	00 00 00 
  8000f5:	41 ff d0             	call   *%r8
        sys_cputs(buf, n);
  8000f8:	48 63 f0             	movslq %eax,%rsi
  8000fb:	48 8d bd df fd ff ff 	lea    -0x221(%rbp),%rdi
  800102:	41 ff d5             	call   *%r13
    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
  800105:	ba 00 02 00 00       	mov    $0x200,%edx
  80010a:	48 8d b5 df fd ff ff 	lea    -0x221(%rbp),%rsi
  800111:	89 df                	mov    %ebx,%edi
  800113:	41 ff d4             	call   *%r12
  800116:	85 c0                	test   %eax,%eax
  800118:	7f de                	jg     8000f8 <umain+0xd3>

    cprintf("icode: close /motd\n");
  80011a:	48 bf 64 40 80 00 00 	movabs $0x804064,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	49 bc 25 04 80 00 00 	movabs $0x800425,%r12
  800130:	00 00 00 
  800133:	41 ff d4             	call   *%r12
    close(fd);
  800136:	89 df                	mov    %ebx,%edi
  800138:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80013f:	00 00 00 
  800142:	ff d0                	call   *%rax

    cprintf("icode: spawn /init\n");
  800144:	48 bf 78 40 80 00 00 	movabs $0x804078,%rdi
  80014b:	00 00 00 
  80014e:	b8 00 00 00 00       	mov    $0x0,%eax
  800153:	41 ff d4             	call   *%r12
    if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char *)0)) < 0)
  800156:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80015c:	48 b9 8c 40 80 00 00 	movabs $0x80408c,%rcx
  800163:	00 00 00 
  800166:	48 ba 95 40 80 00 00 	movabs $0x804095,%rdx
  80016d:	00 00 00 
  800170:	48 be 9f 40 80 00 00 	movabs $0x80409f,%rsi
  800177:	00 00 00 
  80017a:	48 bf 9e 40 80 00 00 	movabs $0x80409e,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	49 b9 23 29 80 00 00 	movabs $0x802923,%r9
  800190:	00 00 00 
  800193:	41 ff d1             	call   *%r9
  800196:	85 c0                	test   %eax,%eax
  800198:	78 29                	js     8001c3 <umain+0x19e>
        panic("icode: spawn /init: %i", r);

    cprintf("icode: exiting\n");
  80019a:	48 bf bb 40 80 00 00 	movabs $0x8040bb,%rdi
  8001a1:	00 00 00 
  8001a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a9:	48 ba 25 04 80 00 00 	movabs $0x800425,%rdx
  8001b0:	00 00 00 
  8001b3:	ff d2                	call   *%rdx
}
  8001b5:	48 81 c4 18 02 00 00 	add    $0x218,%rsp
  8001bc:	5b                   	pop    %rbx
  8001bd:	41 5c                	pop    %r12
  8001bf:	41 5d                	pop    %r13
  8001c1:	5d                   	pop    %rbp
  8001c2:	c3                   	ret
        panic("icode: spawn /init: %i", r);
  8001c3:	89 c1                	mov    %eax,%ecx
  8001c5:	48 ba a4 40 80 00 00 	movabs $0x8040a4,%rdx
  8001cc:	00 00 00 
  8001cf:	be 19 00 00 00       	mov    $0x19,%esi
  8001d4:	48 bf 44 40 80 00 00 	movabs $0x804044,%rdi
  8001db:	00 00 00 
  8001de:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e3:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  8001ea:	00 00 00 
  8001ed:	41 ff d0             	call   *%r8

00000000008001f0 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8001f0:	f3 0f 1e fa          	endbr64
  8001f4:	55                   	push   %rbp
  8001f5:	48 89 e5             	mov    %rsp,%rbp
  8001f8:	41 56                	push   %r14
  8001fa:	41 55                	push   %r13
  8001fc:	41 54                	push   %r12
  8001fe:	53                   	push   %rbx
  8001ff:	41 89 fd             	mov    %edi,%r13d
  800202:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800205:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80020c:	00 00 00 
  80020f:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800216:	00 00 00 
  800219:	48 39 c2             	cmp    %rax,%rdx
  80021c:	73 17                	jae    800235 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80021e:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800221:	49 89 c4             	mov    %rax,%r12
  800224:	48 83 c3 08          	add    $0x8,%rbx
  800228:	b8 00 00 00 00       	mov    $0x0,%eax
  80022d:	ff 53 f8             	call   *-0x8(%rbx)
  800230:	4c 39 e3             	cmp    %r12,%rbx
  800233:	72 ef                	jb     800224 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800235:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	call   *%rax
  800241:	25 ff 03 00 00       	and    $0x3ff,%eax
  800246:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80024a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80024e:	48 c1 e0 04          	shl    $0x4,%rax
  800252:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800259:	00 00 00 
  80025c:	48 01 d0             	add    %rdx,%rax
  80025f:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800266:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800269:	45 85 ed             	test   %r13d,%r13d
  80026c:	7e 0d                	jle    80027b <libmain+0x8b>
  80026e:	49 8b 06             	mov    (%r14),%rax
  800271:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800278:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80027b:	4c 89 f6             	mov    %r14,%rsi
  80027e:	44 89 ef             	mov    %r13d,%edi
  800281:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800288:	00 00 00 
  80028b:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80028d:	48 b8 a2 02 80 00 00 	movabs $0x8002a2,%rax
  800294:	00 00 00 
  800297:	ff d0                	call   *%rax
#endif
}
  800299:	5b                   	pop    %rbx
  80029a:	41 5c                	pop    %r12
  80029c:	41 5d                	pop    %r13
  80029e:	41 5e                	pop    %r14
  8002a0:	5d                   	pop    %rbp
  8002a1:	c3                   	ret

00000000008002a2 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8002a2:	f3 0f 1e fa          	endbr64
  8002a6:	55                   	push   %rbp
  8002a7:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8002aa:	48 b8 79 19 80 00 00 	movabs $0x801979,%rax
  8002b1:	00 00 00 
  8002b4:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8002b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8002bb:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8002c2:	00 00 00 
  8002c5:	ff d0                	call   *%rax
}
  8002c7:	5d                   	pop    %rbp
  8002c8:	c3                   	ret

00000000008002c9 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8002c9:	f3 0f 1e fa          	endbr64
  8002cd:	55                   	push   %rbp
  8002ce:	48 89 e5             	mov    %rsp,%rbp
  8002d1:	41 56                	push   %r14
  8002d3:	41 55                	push   %r13
  8002d5:	41 54                	push   %r12
  8002d7:	53                   	push   %rbx
  8002d8:	48 83 ec 50          	sub    $0x50,%rsp
  8002dc:	49 89 fc             	mov    %rdi,%r12
  8002df:	41 89 f5             	mov    %esi,%r13d
  8002e2:	48 89 d3             	mov    %rdx,%rbx
  8002e5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8002e9:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8002ed:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8002f1:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8002f8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002fc:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800300:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800304:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800308:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80030f:	00 00 00 
  800312:	4c 8b 30             	mov    (%rax),%r14
  800315:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	call   *%rax
  800321:	89 c6                	mov    %eax,%esi
  800323:	45 89 e8             	mov    %r13d,%r8d
  800326:	4c 89 e1             	mov    %r12,%rcx
  800329:	4c 89 f2             	mov    %r14,%rdx
  80032c:	48 bf 90 43 80 00 00 	movabs $0x804390,%rdi
  800333:	00 00 00 
  800336:	b8 00 00 00 00       	mov    $0x0,%eax
  80033b:	49 bc 25 04 80 00 00 	movabs $0x800425,%r12
  800342:	00 00 00 
  800345:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800348:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80034c:	48 89 df             	mov    %rbx,%rdi
  80034f:	48 b8 bd 03 80 00 00 	movabs $0x8003bd,%rax
  800356:	00 00 00 
  800359:	ff d0                	call   *%rax
    cprintf("\n");
  80035b:	48 bf 62 40 80 00 00 	movabs $0x804062,%rdi
  800362:	00 00 00 
  800365:	b8 00 00 00 00       	mov    $0x0,%eax
  80036a:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80036d:	cc                   	int3
  80036e:	eb fd                	jmp    80036d <_panic+0xa4>

0000000000800370 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800370:	f3 0f 1e fa          	endbr64
  800374:	55                   	push   %rbp
  800375:	48 89 e5             	mov    %rsp,%rbp
  800378:	53                   	push   %rbx
  800379:	48 83 ec 08          	sub    $0x8,%rsp
  80037d:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800380:	8b 06                	mov    (%rsi),%eax
  800382:	8d 50 01             	lea    0x1(%rax),%edx
  800385:	89 16                	mov    %edx,(%rsi)
  800387:	48 98                	cltq
  800389:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80038e:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800394:	74 0a                	je     8003a0 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800396:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80039a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80039e:	c9                   	leave
  80039f:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8003a0:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8003a4:	be ff 00 00 00       	mov    $0xff,%esi
  8003a9:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	call   *%rax
        state->offset = 0;
  8003b5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8003bb:	eb d9                	jmp    800396 <putch+0x26>

00000000008003bd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8003bd:	f3 0f 1e fa          	endbr64
  8003c1:	55                   	push   %rbp
  8003c2:	48 89 e5             	mov    %rsp,%rbp
  8003c5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8003cc:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8003cf:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8003d6:	b9 21 00 00 00       	mov    $0x21,%ecx
  8003db:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e0:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8003e3:	48 89 f1             	mov    %rsi,%rcx
  8003e6:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8003ed:	48 bf 70 03 80 00 00 	movabs $0x800370,%rdi
  8003f4:	00 00 00 
  8003f7:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800403:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80040a:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800411:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  800418:	00 00 00 
  80041b:	ff d0                	call   *%rax

    return state.count;
}
  80041d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800423:	c9                   	leave
  800424:	c3                   	ret

0000000000800425 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800425:	f3 0f 1e fa          	endbr64
  800429:	55                   	push   %rbp
  80042a:	48 89 e5             	mov    %rsp,%rbp
  80042d:	48 83 ec 50          	sub    $0x50,%rsp
  800431:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800435:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800439:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80043d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800441:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800445:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80044c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800450:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800454:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800458:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80045c:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800460:	48 b8 bd 03 80 00 00 	movabs $0x8003bd,%rax
  800467:	00 00 00 
  80046a:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80046c:	c9                   	leave
  80046d:	c3                   	ret

000000000080046e <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80046e:	f3 0f 1e fa          	endbr64
  800472:	55                   	push   %rbp
  800473:	48 89 e5             	mov    %rsp,%rbp
  800476:	41 57                	push   %r15
  800478:	41 56                	push   %r14
  80047a:	41 55                	push   %r13
  80047c:	41 54                	push   %r12
  80047e:	53                   	push   %rbx
  80047f:	48 83 ec 18          	sub    $0x18,%rsp
  800483:	49 89 fc             	mov    %rdi,%r12
  800486:	49 89 f5             	mov    %rsi,%r13
  800489:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80048d:	8b 45 10             	mov    0x10(%rbp),%eax
  800490:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800493:	41 89 cf             	mov    %ecx,%r15d
  800496:	4c 39 fa             	cmp    %r15,%rdx
  800499:	73 5b                	jae    8004f6 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80049b:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80049f:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8004a3:	85 db                	test   %ebx,%ebx
  8004a5:	7e 0e                	jle    8004b5 <print_num+0x47>
            putch(padc, put_arg);
  8004a7:	4c 89 ee             	mov    %r13,%rsi
  8004aa:	44 89 f7             	mov    %r14d,%edi
  8004ad:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8004b0:	83 eb 01             	sub    $0x1,%ebx
  8004b3:	75 f2                	jne    8004a7 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8004b5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8004b9:	48 b9 e6 40 80 00 00 	movabs $0x8040e6,%rcx
  8004c0:	00 00 00 
  8004c3:	48 b8 d5 40 80 00 00 	movabs $0x8040d5,%rax
  8004ca:	00 00 00 
  8004cd:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8004d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	49 f7 f7             	div    %r15
  8004dd:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8004e1:	4c 89 ee             	mov    %r13,%rsi
  8004e4:	41 ff d4             	call   *%r12
}
  8004e7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8004eb:	5b                   	pop    %rbx
  8004ec:	41 5c                	pop    %r12
  8004ee:	41 5d                	pop    %r13
  8004f0:	41 5e                	pop    %r14
  8004f2:	41 5f                	pop    %r15
  8004f4:	5d                   	pop    %rbp
  8004f5:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8004f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ff:	49 f7 f7             	div    %r15
  800502:	48 83 ec 08          	sub    $0x8,%rsp
  800506:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80050a:	52                   	push   %rdx
  80050b:	45 0f be c9          	movsbl %r9b,%r9d
  80050f:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800513:	48 89 c2             	mov    %rax,%rdx
  800516:	48 b8 6e 04 80 00 00 	movabs $0x80046e,%rax
  80051d:	00 00 00 
  800520:	ff d0                	call   *%rax
  800522:	48 83 c4 10          	add    $0x10,%rsp
  800526:	eb 8d                	jmp    8004b5 <print_num+0x47>

0000000000800528 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800528:	f3 0f 1e fa          	endbr64
    state->count++;
  80052c:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800530:	48 8b 06             	mov    (%rsi),%rax
  800533:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800537:	73 0a                	jae    800543 <sprintputch+0x1b>
        *state->start++ = ch;
  800539:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80053d:	48 89 16             	mov    %rdx,(%rsi)
  800540:	40 88 38             	mov    %dil,(%rax)
    }
}
  800543:	c3                   	ret

0000000000800544 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800544:	f3 0f 1e fa          	endbr64
  800548:	55                   	push   %rbp
  800549:	48 89 e5             	mov    %rsp,%rbp
  80054c:	48 83 ec 50          	sub    $0x50,%rsp
  800550:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800554:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800558:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80055c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800563:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800567:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80056b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80056f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800573:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800577:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  80057e:	00 00 00 
  800581:	ff d0                	call   *%rax
}
  800583:	c9                   	leave
  800584:	c3                   	ret

0000000000800585 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800585:	f3 0f 1e fa          	endbr64
  800589:	55                   	push   %rbp
  80058a:	48 89 e5             	mov    %rsp,%rbp
  80058d:	41 57                	push   %r15
  80058f:	41 56                	push   %r14
  800591:	41 55                	push   %r13
  800593:	41 54                	push   %r12
  800595:	53                   	push   %rbx
  800596:	48 83 ec 38          	sub    $0x38,%rsp
  80059a:	49 89 fe             	mov    %rdi,%r14
  80059d:	49 89 f5             	mov    %rsi,%r13
  8005a0:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8005a3:	48 8b 01             	mov    (%rcx),%rax
  8005a6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8005aa:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8005ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005b2:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8005b6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8005ba:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8005be:	0f b6 3b             	movzbl (%rbx),%edi
  8005c1:	40 80 ff 25          	cmp    $0x25,%dil
  8005c5:	74 18                	je     8005df <vprintfmt+0x5a>
            if (!ch) return;
  8005c7:	40 84 ff             	test   %dil,%dil
  8005ca:	0f 84 b2 06 00 00    	je     800c82 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8005d0:	40 0f b6 ff          	movzbl %dil,%edi
  8005d4:	4c 89 ee             	mov    %r13,%rsi
  8005d7:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8005da:	4c 89 e3             	mov    %r12,%rbx
  8005dd:	eb db                	jmp    8005ba <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8005df:	be 00 00 00 00       	mov    $0x0,%esi
  8005e4:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8005ed:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005f3:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8005fa:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005fe:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800603:	41 0f b6 04 24       	movzbl (%r12),%eax
  800608:	88 45 a0             	mov    %al,-0x60(%rbp)
  80060b:	83 e8 23             	sub    $0x23,%eax
  80060e:	3c 57                	cmp    $0x57,%al
  800610:	0f 87 52 06 00 00    	ja     800c68 <vprintfmt+0x6e3>
  800616:	0f b6 c0             	movzbl %al,%eax
  800619:	48 b9 e0 44 80 00 00 	movabs $0x8044e0,%rcx
  800620:	00 00 00 
  800623:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800627:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80062a:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80062e:	eb ce                	jmp    8005fe <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800630:	49 89 dc             	mov    %rbx,%r12
  800633:	be 01 00 00 00       	mov    $0x1,%esi
  800638:	eb c4                	jmp    8005fe <vprintfmt+0x79>
            padc = ch;
  80063a:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80063e:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800641:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800644:	eb b8                	jmp    8005fe <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800646:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800649:	83 f8 2f             	cmp    $0x2f,%eax
  80064c:	77 24                	ja     800672 <vprintfmt+0xed>
  80064e:	89 c1                	mov    %eax,%ecx
  800650:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800654:	83 c0 08             	add    $0x8,%eax
  800657:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80065a:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80065d:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800660:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800664:	79 98                	jns    8005fe <vprintfmt+0x79>
                width = precision;
  800666:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80066a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800670:	eb 8c                	jmp    8005fe <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800672:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800676:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80067a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80067e:	eb da                	jmp    80065a <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800680:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800685:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800689:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80068f:	3c 39                	cmp    $0x39,%al
  800691:	77 1c                	ja     8006af <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800693:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800697:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80069b:	0f b6 c0             	movzbl %al,%eax
  80069e:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8006a3:	0f b6 03             	movzbl (%rbx),%eax
  8006a6:	3c 39                	cmp    $0x39,%al
  8006a8:	76 e9                	jbe    800693 <vprintfmt+0x10e>
        process_precision:
  8006aa:	49 89 dc             	mov    %rbx,%r12
  8006ad:	eb b1                	jmp    800660 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8006af:	49 89 dc             	mov    %rbx,%r12
  8006b2:	eb ac                	jmp    800660 <vprintfmt+0xdb>
            width = MAX(0, width);
  8006b4:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8006b7:	85 c9                	test   %ecx,%ecx
  8006b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006be:	0f 49 c1             	cmovns %ecx,%eax
  8006c1:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8006c4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8006c7:	e9 32 ff ff ff       	jmp    8005fe <vprintfmt+0x79>
            lflag++;
  8006cc:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8006cf:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8006d2:	e9 27 ff ff ff       	jmp    8005fe <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8006d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006da:	83 f8 2f             	cmp    $0x2f,%eax
  8006dd:	77 19                	ja     8006f8 <vprintfmt+0x173>
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006e5:	83 c0 08             	add    $0x8,%eax
  8006e8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006eb:	8b 3a                	mov    (%rdx),%edi
  8006ed:	4c 89 ee             	mov    %r13,%rsi
  8006f0:	41 ff d6             	call   *%r14
            break;
  8006f3:	e9 c2 fe ff ff       	jmp    8005ba <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8006f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006fc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800700:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800704:	eb e5                	jmp    8006eb <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800706:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800709:	83 f8 2f             	cmp    $0x2f,%eax
  80070c:	77 5a                	ja     800768 <vprintfmt+0x1e3>
  80070e:	89 c2                	mov    %eax,%edx
  800710:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800714:	83 c0 08             	add    $0x8,%eax
  800717:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80071a:	8b 02                	mov    (%rdx),%eax
  80071c:	89 c1                	mov    %eax,%ecx
  80071e:	f7 d9                	neg    %ecx
  800720:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800723:	83 f9 13             	cmp    $0x13,%ecx
  800726:	7f 4e                	jg     800776 <vprintfmt+0x1f1>
  800728:	48 63 c1             	movslq %ecx,%rax
  80072b:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  800732:	00 00 00 
  800735:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800739:	48 85 c0             	test   %rax,%rax
  80073c:	74 38                	je     800776 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80073e:	48 89 c1             	mov    %rax,%rcx
  800741:	48 ba da 42 80 00 00 	movabs $0x8042da,%rdx
  800748:	00 00 00 
  80074b:	4c 89 ee             	mov    %r13,%rsi
  80074e:	4c 89 f7             	mov    %r14,%rdi
  800751:	b8 00 00 00 00       	mov    $0x0,%eax
  800756:	49 b8 44 05 80 00 00 	movabs $0x800544,%r8
  80075d:	00 00 00 
  800760:	41 ff d0             	call   *%r8
  800763:	e9 52 fe ff ff       	jmp    8005ba <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800768:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80076c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800770:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800774:	eb a4                	jmp    80071a <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800776:	48 ba fe 40 80 00 00 	movabs $0x8040fe,%rdx
  80077d:	00 00 00 
  800780:	4c 89 ee             	mov    %r13,%rsi
  800783:	4c 89 f7             	mov    %r14,%rdi
  800786:	b8 00 00 00 00       	mov    $0x0,%eax
  80078b:	49 b8 44 05 80 00 00 	movabs $0x800544,%r8
  800792:	00 00 00 
  800795:	41 ff d0             	call   *%r8
  800798:	e9 1d fe ff ff       	jmp    8005ba <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80079d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a0:	83 f8 2f             	cmp    $0x2f,%eax
  8007a3:	77 6c                	ja     800811 <vprintfmt+0x28c>
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007ab:	83 c0 08             	add    $0x8,%eax
  8007ae:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b1:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8007b4:	48 85 d2             	test   %rdx,%rdx
  8007b7:	48 b8 f7 40 80 00 00 	movabs $0x8040f7,%rax
  8007be:	00 00 00 
  8007c1:	48 0f 45 c2          	cmovne %rdx,%rax
  8007c5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8007c9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007cd:	7e 06                	jle    8007d5 <vprintfmt+0x250>
  8007cf:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8007d3:	75 4a                	jne    80081f <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007d9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8007dd:	0f b6 00             	movzbl (%rax),%eax
  8007e0:	84 c0                	test   %al,%al
  8007e2:	0f 85 9a 00 00 00    	jne    800882 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8007e8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007eb:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	0f 8e c3 fd ff ff    	jle    8005ba <vprintfmt+0x35>
  8007f7:	4c 89 ee             	mov    %r13,%rsi
  8007fa:	bf 20 00 00 00       	mov    $0x20,%edi
  8007ff:	41 ff d6             	call   *%r14
  800802:	41 83 ec 01          	sub    $0x1,%r12d
  800806:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80080a:	75 eb                	jne    8007f7 <vprintfmt+0x272>
  80080c:	e9 a9 fd ff ff       	jmp    8005ba <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800811:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800815:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800819:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80081d:	eb 92                	jmp    8007b1 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80081f:	49 63 f7             	movslq %r15d,%rsi
  800822:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800826:	48 b8 48 0d 80 00 00 	movabs $0x800d48,%rax
  80082d:	00 00 00 
  800830:	ff d0                	call   *%rax
  800832:	48 89 c2             	mov    %rax,%rdx
  800835:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800838:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80083a:	8d 70 ff             	lea    -0x1(%rax),%esi
  80083d:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800840:	85 c0                	test   %eax,%eax
  800842:	7e 91                	jle    8007d5 <vprintfmt+0x250>
  800844:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800849:	4c 89 ee             	mov    %r13,%rsi
  80084c:	44 89 e7             	mov    %r12d,%edi
  80084f:	41 ff d6             	call   *%r14
  800852:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800856:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800859:	83 f8 ff             	cmp    $0xffffffff,%eax
  80085c:	75 eb                	jne    800849 <vprintfmt+0x2c4>
  80085e:	e9 72 ff ff ff       	jmp    8007d5 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800863:	0f b6 f8             	movzbl %al,%edi
  800866:	4c 89 ee             	mov    %r13,%rsi
  800869:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80086c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800870:	49 83 c4 01          	add    $0x1,%r12
  800874:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80087a:	84 c0                	test   %al,%al
  80087c:	0f 84 66 ff ff ff    	je     8007e8 <vprintfmt+0x263>
  800882:	45 85 ff             	test   %r15d,%r15d
  800885:	78 0a                	js     800891 <vprintfmt+0x30c>
  800887:	41 83 ef 01          	sub    $0x1,%r15d
  80088b:	0f 88 57 ff ff ff    	js     8007e8 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800891:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800895:	74 cc                	je     800863 <vprintfmt+0x2de>
  800897:	8d 50 e0             	lea    -0x20(%rax),%edx
  80089a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80089f:	80 fa 5e             	cmp    $0x5e,%dl
  8008a2:	77 c2                	ja     800866 <vprintfmt+0x2e1>
  8008a4:	eb bd                	jmp    800863 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8008a6:	40 84 f6             	test   %sil,%sil
  8008a9:	75 26                	jne    8008d1 <vprintfmt+0x34c>
    switch (lflag) {
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	74 59                	je     800908 <vprintfmt+0x383>
  8008af:	83 fa 01             	cmp    $0x1,%edx
  8008b2:	74 7b                	je     80092f <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8008b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b7:	83 f8 2f             	cmp    $0x2f,%eax
  8008ba:	0f 87 96 00 00 00    	ja     800956 <vprintfmt+0x3d1>
  8008c0:	89 c2                	mov    %eax,%edx
  8008c2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c6:	83 c0 08             	add    $0x8,%eax
  8008c9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008cc:	4c 8b 22             	mov    (%rdx),%r12
  8008cf:	eb 17                	jmp    8008e8 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8008d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d4:	83 f8 2f             	cmp    $0x2f,%eax
  8008d7:	77 21                	ja     8008fa <vprintfmt+0x375>
  8008d9:	89 c2                	mov    %eax,%edx
  8008db:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008df:	83 c0 08             	add    $0x8,%eax
  8008e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e5:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8008e8:	4d 85 e4             	test   %r12,%r12
  8008eb:	78 7a                	js     800967 <vprintfmt+0x3e2>
            num = i;
  8008ed:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8008f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008f5:	e9 50 02 00 00       	jmp    800b4a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800902:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800906:	eb dd                	jmp    8008e5 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800908:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090b:	83 f8 2f             	cmp    $0x2f,%eax
  80090e:	77 11                	ja     800921 <vprintfmt+0x39c>
  800910:	89 c2                	mov    %eax,%edx
  800912:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800916:	83 c0 08             	add    $0x8,%eax
  800919:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091c:	4c 63 22             	movslq (%rdx),%r12
  80091f:	eb c7                	jmp    8008e8 <vprintfmt+0x363>
  800921:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800925:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800929:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80092d:	eb ed                	jmp    80091c <vprintfmt+0x397>
        return va_arg(*ap, long);
  80092f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800932:	83 f8 2f             	cmp    $0x2f,%eax
  800935:	77 11                	ja     800948 <vprintfmt+0x3c3>
  800937:	89 c2                	mov    %eax,%edx
  800939:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80093d:	83 c0 08             	add    $0x8,%eax
  800940:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800943:	4c 8b 22             	mov    (%rdx),%r12
  800946:	eb a0                	jmp    8008e8 <vprintfmt+0x363>
  800948:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800950:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800954:	eb ed                	jmp    800943 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800956:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80095e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800962:	e9 65 ff ff ff       	jmp    8008cc <vprintfmt+0x347>
                putch('-', put_arg);
  800967:	4c 89 ee             	mov    %r13,%rsi
  80096a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80096f:	41 ff d6             	call   *%r14
                i = -i;
  800972:	49 f7 dc             	neg    %r12
  800975:	e9 73 ff ff ff       	jmp    8008ed <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80097a:	40 84 f6             	test   %sil,%sil
  80097d:	75 32                	jne    8009b1 <vprintfmt+0x42c>
    switch (lflag) {
  80097f:	85 d2                	test   %edx,%edx
  800981:	74 5d                	je     8009e0 <vprintfmt+0x45b>
  800983:	83 fa 01             	cmp    $0x1,%edx
  800986:	0f 84 82 00 00 00    	je     800a0e <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80098c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098f:	83 f8 2f             	cmp    $0x2f,%eax
  800992:	0f 87 a5 00 00 00    	ja     800a3d <vprintfmt+0x4b8>
  800998:	89 c2                	mov    %eax,%edx
  80099a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80099e:	83 c0 08             	add    $0x8,%eax
  8009a1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a4:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8009ac:	e9 99 01 00 00       	jmp    800b4a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b4:	83 f8 2f             	cmp    $0x2f,%eax
  8009b7:	77 19                	ja     8009d2 <vprintfmt+0x44d>
  8009b9:	89 c2                	mov    %eax,%edx
  8009bb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c5:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009cd:	e9 78 01 00 00       	jmp    800b4a <vprintfmt+0x5c5>
  8009d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009de:	eb e5                	jmp    8009c5 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	83 f8 2f             	cmp    $0x2f,%eax
  8009e6:	77 18                	ja     800a00 <vprintfmt+0x47b>
  8009e8:	89 c2                	mov    %eax,%edx
  8009ea:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009ee:	83 c0 08             	add    $0x8,%eax
  8009f1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f4:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8009f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009fb:	e9 4a 01 00 00       	jmp    800b4a <vprintfmt+0x5c5>
  800a00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a04:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0c:	eb e6                	jmp    8009f4 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800a0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a11:	83 f8 2f             	cmp    $0x2f,%eax
  800a14:	77 19                	ja     800a2f <vprintfmt+0x4aa>
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a1c:	83 c0 08             	add    $0x8,%eax
  800a1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a22:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a25:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800a2a:	e9 1b 01 00 00       	jmp    800b4a <vprintfmt+0x5c5>
  800a2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a33:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3b:	eb e5                	jmp    800a22 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800a3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a41:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a45:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a49:	e9 56 ff ff ff       	jmp    8009a4 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800a4e:	40 84 f6             	test   %sil,%sil
  800a51:	75 2e                	jne    800a81 <vprintfmt+0x4fc>
    switch (lflag) {
  800a53:	85 d2                	test   %edx,%edx
  800a55:	74 59                	je     800ab0 <vprintfmt+0x52b>
  800a57:	83 fa 01             	cmp    $0x1,%edx
  800a5a:	74 7f                	je     800adb <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800a5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5f:	83 f8 2f             	cmp    $0x2f,%eax
  800a62:	0f 87 9f 00 00 00    	ja     800b07 <vprintfmt+0x582>
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a6e:	83 c0 08             	add    $0x8,%eax
  800a71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a74:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a77:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a7c:	e9 c9 00 00 00       	jmp    800b4a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a84:	83 f8 2f             	cmp    $0x2f,%eax
  800a87:	77 19                	ja     800aa2 <vprintfmt+0x51d>
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8f:	83 c0 08             	add    $0x8,%eax
  800a92:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a95:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a98:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a9d:	e9 a8 00 00 00       	jmp    800b4a <vprintfmt+0x5c5>
  800aa2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aaa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aae:	eb e5                	jmp    800a95 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800ab0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab3:	83 f8 2f             	cmp    $0x2f,%eax
  800ab6:	77 15                	ja     800acd <vprintfmt+0x548>
  800ab8:	89 c2                	mov    %eax,%edx
  800aba:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800abe:	83 c0 08             	add    $0x8,%eax
  800ac1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac4:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800ac6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800acb:	eb 7d                	jmp    800b4a <vprintfmt+0x5c5>
  800acd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad9:	eb e9                	jmp    800ac4 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800adb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ade:	83 f8 2f             	cmp    $0x2f,%eax
  800ae1:	77 16                	ja     800af9 <vprintfmt+0x574>
  800ae3:	89 c2                	mov    %eax,%edx
  800ae5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ae9:	83 c0 08             	add    $0x8,%eax
  800aec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aef:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800af2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800af7:	eb 51                	jmp    800b4a <vprintfmt+0x5c5>
  800af9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b05:	eb e8                	jmp    800aef <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800b07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b0f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b13:	e9 5c ff ff ff       	jmp    800a74 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800b18:	4c 89 ee             	mov    %r13,%rsi
  800b1b:	bf 30 00 00 00       	mov    $0x30,%edi
  800b20:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800b23:	4c 89 ee             	mov    %r13,%rsi
  800b26:	bf 78 00 00 00       	mov    $0x78,%edi
  800b2b:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800b2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b31:	83 f8 2f             	cmp    $0x2f,%eax
  800b34:	77 47                	ja     800b7d <vprintfmt+0x5f8>
  800b36:	89 c2                	mov    %eax,%edx
  800b38:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b3c:	83 c0 08             	add    $0x8,%eax
  800b3f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b42:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b45:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b4a:	48 83 ec 08          	sub    $0x8,%rsp
  800b4e:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800b52:	0f 94 c0             	sete   %al
  800b55:	0f b6 c0             	movzbl %al,%eax
  800b58:	50                   	push   %rax
  800b59:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800b5e:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b62:	4c 89 ee             	mov    %r13,%rsi
  800b65:	4c 89 f7             	mov    %r14,%rdi
  800b68:	48 b8 6e 04 80 00 00 	movabs $0x80046e,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	call   *%rax
            break;
  800b74:	48 83 c4 10          	add    $0x10,%rsp
  800b78:	e9 3d fa ff ff       	jmp    8005ba <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800b7d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b81:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b89:	eb b7                	jmp    800b42 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800b8b:	40 84 f6             	test   %sil,%sil
  800b8e:	75 2b                	jne    800bbb <vprintfmt+0x636>
    switch (lflag) {
  800b90:	85 d2                	test   %edx,%edx
  800b92:	74 56                	je     800bea <vprintfmt+0x665>
  800b94:	83 fa 01             	cmp    $0x1,%edx
  800b97:	74 7f                	je     800c18 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9c:	83 f8 2f             	cmp    $0x2f,%eax
  800b9f:	0f 87 a2 00 00 00    	ja     800c47 <vprintfmt+0x6c2>
  800ba5:	89 c2                	mov    %eax,%edx
  800ba7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bab:	83 c0 08             	add    $0x8,%eax
  800bae:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bb1:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bb4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800bb9:	eb 8f                	jmp    800b4a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800bbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbe:	83 f8 2f             	cmp    $0x2f,%eax
  800bc1:	77 19                	ja     800bdc <vprintfmt+0x657>
  800bc3:	89 c2                	mov    %eax,%edx
  800bc5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bc9:	83 c0 08             	add    $0x8,%eax
  800bcc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bcf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bd2:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800bd7:	e9 6e ff ff ff       	jmp    800b4a <vprintfmt+0x5c5>
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800be4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be8:	eb e5                	jmp    800bcf <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800bea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bed:	83 f8 2f             	cmp    $0x2f,%eax
  800bf0:	77 18                	ja     800c0a <vprintfmt+0x685>
  800bf2:	89 c2                	mov    %eax,%edx
  800bf4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bf8:	83 c0 08             	add    $0x8,%eax
  800bfb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bfe:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800c00:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800c05:	e9 40 ff ff ff       	jmp    800b4a <vprintfmt+0x5c5>
  800c0a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c12:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c16:	eb e6                	jmp    800bfe <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800c18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1b:	83 f8 2f             	cmp    $0x2f,%eax
  800c1e:	77 19                	ja     800c39 <vprintfmt+0x6b4>
  800c20:	89 c2                	mov    %eax,%edx
  800c22:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c26:	83 c0 08             	add    $0x8,%eax
  800c29:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c2c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c2f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800c34:	e9 11 ff ff ff       	jmp    800b4a <vprintfmt+0x5c5>
  800c39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c3d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c45:	eb e5                	jmp    800c2c <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800c47:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c4b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c4f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c53:	e9 59 ff ff ff       	jmp    800bb1 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800c58:	4c 89 ee             	mov    %r13,%rsi
  800c5b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c60:	41 ff d6             	call   *%r14
            break;
  800c63:	e9 52 f9 ff ff       	jmp    8005ba <vprintfmt+0x35>
            putch('%', put_arg);
  800c68:	4c 89 ee             	mov    %r13,%rsi
  800c6b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c70:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800c73:	48 83 eb 01          	sub    $0x1,%rbx
  800c77:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800c7b:	75 f6                	jne    800c73 <vprintfmt+0x6ee>
  800c7d:	e9 38 f9 ff ff       	jmp    8005ba <vprintfmt+0x35>
}
  800c82:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c86:	5b                   	pop    %rbx
  800c87:	41 5c                	pop    %r12
  800c89:	41 5d                	pop    %r13
  800c8b:	41 5e                	pop    %r14
  800c8d:	41 5f                	pop    %r15
  800c8f:	5d                   	pop    %rbp
  800c90:	c3                   	ret

0000000000800c91 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c91:	f3 0f 1e fa          	endbr64
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ca1:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800ca6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800caa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800cb1:	48 85 ff             	test   %rdi,%rdi
  800cb4:	74 2b                	je     800ce1 <vsnprintf+0x50>
  800cb6:	48 85 f6             	test   %rsi,%rsi
  800cb9:	74 26                	je     800ce1 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800cbb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800cbf:	48 bf 28 05 80 00 00 	movabs $0x800528,%rdi
  800cc6:	00 00 00 
  800cc9:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  800cd0:	00 00 00 
  800cd3:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd9:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800cdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800cdf:	c9                   	leave
  800ce0:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800ce1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce6:	eb f7                	jmp    800cdf <vsnprintf+0x4e>

0000000000800ce8 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ce8:	f3 0f 1e fa          	endbr64
  800cec:	55                   	push   %rbp
  800ced:	48 89 e5             	mov    %rsp,%rbp
  800cf0:	48 83 ec 50          	sub    $0x50,%rsp
  800cf4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cf8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cfc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800d00:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800d07:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d0b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d0f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d13:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800d17:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800d1b:	48 b8 91 0c 80 00 00 	movabs $0x800c91,%rax
  800d22:	00 00 00 
  800d25:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800d27:	c9                   	leave
  800d28:	c3                   	ret

0000000000800d29 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800d29:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800d2d:	80 3f 00             	cmpb   $0x0,(%rdi)
  800d30:	74 10                	je     800d42 <strlen+0x19>
    size_t n = 0;
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800d37:	48 83 c0 01          	add    $0x1,%rax
  800d3b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d3f:	75 f6                	jne    800d37 <strlen+0xe>
  800d41:	c3                   	ret
    size_t n = 0;
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d47:	c3                   	ret

0000000000800d48 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800d48:	f3 0f 1e fa          	endbr64
  800d4c:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800d4f:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800d54:	48 85 f6             	test   %rsi,%rsi
  800d57:	74 10                	je     800d69 <strnlen+0x21>
  800d59:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800d5d:	74 0b                	je     800d6a <strnlen+0x22>
  800d5f:	48 83 c2 01          	add    $0x1,%rdx
  800d63:	48 39 d0             	cmp    %rdx,%rax
  800d66:	75 f1                	jne    800d59 <strnlen+0x11>
  800d68:	c3                   	ret
  800d69:	c3                   	ret
  800d6a:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800d6d:	c3                   	ret

0000000000800d6e <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800d6e:	f3 0f 1e fa          	endbr64
  800d72:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d75:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7a:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800d7e:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800d81:	48 83 c2 01          	add    $0x1,%rdx
  800d85:	84 c9                	test   %cl,%cl
  800d87:	75 f1                	jne    800d7a <strcpy+0xc>
        ;
    return res;
}
  800d89:	c3                   	ret

0000000000800d8a <strcat>:

char *
strcat(char *dst, const char *src) {
  800d8a:	f3 0f 1e fa          	endbr64
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
  800d92:	41 54                	push   %r12
  800d94:	53                   	push   %rbx
  800d95:	48 89 fb             	mov    %rdi,%rbx
  800d98:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d9b:	48 b8 29 0d 80 00 00 	movabs $0x800d29,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800da7:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800dab:	4c 89 e6             	mov    %r12,%rsi
  800dae:	48 b8 6e 0d 80 00 00 	movabs $0x800d6e,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	call   *%rax
    return dst;
}
  800dba:	48 89 d8             	mov    %rbx,%rax
  800dbd:	5b                   	pop    %rbx
  800dbe:	41 5c                	pop    %r12
  800dc0:	5d                   	pop    %rbp
  800dc1:	c3                   	ret

0000000000800dc2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dc2:	f3 0f 1e fa          	endbr64
  800dc6:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800dc9:	48 85 d2             	test   %rdx,%rdx
  800dcc:	74 1f                	je     800ded <strncpy+0x2b>
  800dce:	48 01 fa             	add    %rdi,%rdx
  800dd1:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800dd4:	48 83 c1 01          	add    $0x1,%rcx
  800dd8:	44 0f b6 06          	movzbl (%rsi),%r8d
  800ddc:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800de0:	41 80 f8 01          	cmp    $0x1,%r8b
  800de4:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800de8:	48 39 ca             	cmp    %rcx,%rdx
  800deb:	75 e7                	jne    800dd4 <strncpy+0x12>
    }
    return ret;
}
  800ded:	c3                   	ret

0000000000800dee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800dee:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800df2:	48 89 f8             	mov    %rdi,%rax
  800df5:	48 85 d2             	test   %rdx,%rdx
  800df8:	74 24                	je     800e1e <strlcpy+0x30>
        while (--size > 0 && *src)
  800dfa:	48 83 ea 01          	sub    $0x1,%rdx
  800dfe:	74 1b                	je     800e1b <strlcpy+0x2d>
  800e00:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e04:	0f b6 16             	movzbl (%rsi),%edx
  800e07:	84 d2                	test   %dl,%dl
  800e09:	74 10                	je     800e1b <strlcpy+0x2d>
            *dst++ = *src++;
  800e0b:	48 83 c6 01          	add    $0x1,%rsi
  800e0f:	48 83 c0 01          	add    $0x1,%rax
  800e13:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800e16:	48 39 c8             	cmp    %rcx,%rax
  800e19:	75 e9                	jne    800e04 <strlcpy+0x16>
        *dst = '\0';
  800e1b:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800e1e:	48 29 f8             	sub    %rdi,%rax
}
  800e21:	c3                   	ret

0000000000800e22 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800e22:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800e26:	0f b6 07             	movzbl (%rdi),%eax
  800e29:	84 c0                	test   %al,%al
  800e2b:	74 13                	je     800e40 <strcmp+0x1e>
  800e2d:	38 06                	cmp    %al,(%rsi)
  800e2f:	75 0f                	jne    800e40 <strcmp+0x1e>
  800e31:	48 83 c7 01          	add    $0x1,%rdi
  800e35:	48 83 c6 01          	add    $0x1,%rsi
  800e39:	0f b6 07             	movzbl (%rdi),%eax
  800e3c:	84 c0                	test   %al,%al
  800e3e:	75 ed                	jne    800e2d <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	0f b6 16             	movzbl (%rsi),%edx
  800e46:	29 d0                	sub    %edx,%eax
}
  800e48:	c3                   	ret

0000000000800e49 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800e49:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800e4d:	48 85 d2             	test   %rdx,%rdx
  800e50:	74 1f                	je     800e71 <strncmp+0x28>
  800e52:	0f b6 07             	movzbl (%rdi),%eax
  800e55:	84 c0                	test   %al,%al
  800e57:	74 1e                	je     800e77 <strncmp+0x2e>
  800e59:	3a 06                	cmp    (%rsi),%al
  800e5b:	75 1a                	jne    800e77 <strncmp+0x2e>
  800e5d:	48 83 c7 01          	add    $0x1,%rdi
  800e61:	48 83 c6 01          	add    $0x1,%rsi
  800e65:	48 83 ea 01          	sub    $0x1,%rdx
  800e69:	75 e7                	jne    800e52 <strncmp+0x9>

    if (!n) return 0;
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e70:	c3                   	ret
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
  800e76:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e77:	0f b6 07             	movzbl (%rdi),%eax
  800e7a:	0f b6 16             	movzbl (%rsi),%edx
  800e7d:	29 d0                	sub    %edx,%eax
}
  800e7f:	c3                   	ret

0000000000800e80 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800e80:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800e84:	0f b6 17             	movzbl (%rdi),%edx
  800e87:	84 d2                	test   %dl,%dl
  800e89:	74 18                	je     800ea3 <strchr+0x23>
        if (*str == c) {
  800e8b:	0f be d2             	movsbl %dl,%edx
  800e8e:	39 f2                	cmp    %esi,%edx
  800e90:	74 17                	je     800ea9 <strchr+0x29>
    for (; *str; str++) {
  800e92:	48 83 c7 01          	add    $0x1,%rdi
  800e96:	0f b6 17             	movzbl (%rdi),%edx
  800e99:	84 d2                	test   %dl,%dl
  800e9b:	75 ee                	jne    800e8b <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea2:	c3                   	ret
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea8:	c3                   	ret
            return (char *)str;
  800ea9:	48 89 f8             	mov    %rdi,%rax
}
  800eac:	c3                   	ret

0000000000800ead <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800ead:	f3 0f 1e fa          	endbr64
  800eb1:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800eb4:	0f b6 17             	movzbl (%rdi),%edx
  800eb7:	84 d2                	test   %dl,%dl
  800eb9:	74 13                	je     800ece <strfind+0x21>
  800ebb:	0f be d2             	movsbl %dl,%edx
  800ebe:	39 f2                	cmp    %esi,%edx
  800ec0:	74 0b                	je     800ecd <strfind+0x20>
  800ec2:	48 83 c0 01          	add    $0x1,%rax
  800ec6:	0f b6 10             	movzbl (%rax),%edx
  800ec9:	84 d2                	test   %dl,%dl
  800ecb:	75 ee                	jne    800ebb <strfind+0xe>
        ;
    return (char *)str;
}
  800ecd:	c3                   	ret
  800ece:	c3                   	ret

0000000000800ecf <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800ecf:	f3 0f 1e fa          	endbr64
  800ed3:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800ed6:	48 89 f8             	mov    %rdi,%rax
  800ed9:	48 f7 d8             	neg    %rax
  800edc:	83 e0 07             	and    $0x7,%eax
  800edf:	49 89 d1             	mov    %rdx,%r9
  800ee2:	49 29 c1             	sub    %rax,%r9
  800ee5:	78 36                	js     800f1d <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ee7:	40 0f b6 c6          	movzbl %sil,%eax
  800eeb:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800ef2:	01 01 01 
  800ef5:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800ef9:	40 f6 c7 07          	test   $0x7,%dil
  800efd:	75 38                	jne    800f37 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800eff:	4c 89 c9             	mov    %r9,%rcx
  800f02:	48 c1 f9 03          	sar    $0x3,%rcx
  800f06:	74 0c                	je     800f14 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800f08:	fc                   	cld
  800f09:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800f0c:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800f10:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800f14:	4d 85 c9             	test   %r9,%r9
  800f17:	75 45                	jne    800f5e <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800f19:	4c 89 c0             	mov    %r8,%rax
  800f1c:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800f1d:	48 85 d2             	test   %rdx,%rdx
  800f20:	74 f7                	je     800f19 <memset+0x4a>
  800f22:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800f25:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800f28:	48 83 c0 01          	add    $0x1,%rax
  800f2c:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800f30:	48 39 c2             	cmp    %rax,%rdx
  800f33:	75 f3                	jne    800f28 <memset+0x59>
  800f35:	eb e2                	jmp    800f19 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800f37:	40 f6 c7 01          	test   $0x1,%dil
  800f3b:	74 06                	je     800f43 <memset+0x74>
  800f3d:	88 07                	mov    %al,(%rdi)
  800f3f:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f43:	40 f6 c7 02          	test   $0x2,%dil
  800f47:	74 07                	je     800f50 <memset+0x81>
  800f49:	66 89 07             	mov    %ax,(%rdi)
  800f4c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f50:	40 f6 c7 04          	test   $0x4,%dil
  800f54:	74 a9                	je     800eff <memset+0x30>
  800f56:	89 07                	mov    %eax,(%rdi)
  800f58:	48 83 c7 04          	add    $0x4,%rdi
  800f5c:	eb a1                	jmp    800eff <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f5e:	41 f6 c1 04          	test   $0x4,%r9b
  800f62:	74 1b                	je     800f7f <memset+0xb0>
  800f64:	89 07                	mov    %eax,(%rdi)
  800f66:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f6a:	41 f6 c1 02          	test   $0x2,%r9b
  800f6e:	74 07                	je     800f77 <memset+0xa8>
  800f70:	66 89 07             	mov    %ax,(%rdi)
  800f73:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f77:	41 f6 c1 01          	test   $0x1,%r9b
  800f7b:	74 9c                	je     800f19 <memset+0x4a>
  800f7d:	eb 06                	jmp    800f85 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f7f:	41 f6 c1 02          	test   $0x2,%r9b
  800f83:	75 eb                	jne    800f70 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800f85:	88 07                	mov    %al,(%rdi)
  800f87:	eb 90                	jmp    800f19 <memset+0x4a>

0000000000800f89 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f89:	f3 0f 1e fa          	endbr64
  800f8d:	48 89 f8             	mov    %rdi,%rax
  800f90:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f93:	48 39 fe             	cmp    %rdi,%rsi
  800f96:	73 3b                	jae    800fd3 <memmove+0x4a>
  800f98:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f9c:	48 39 d7             	cmp    %rdx,%rdi
  800f9f:	73 32                	jae    800fd3 <memmove+0x4a>
        s += n;
        d += n;
  800fa1:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800fa5:	48 89 d6             	mov    %rdx,%rsi
  800fa8:	48 09 fe             	or     %rdi,%rsi
  800fab:	48 09 ce             	or     %rcx,%rsi
  800fae:	40 f6 c6 07          	test   $0x7,%sil
  800fb2:	75 12                	jne    800fc6 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800fb4:	48 83 ef 08          	sub    $0x8,%rdi
  800fb8:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800fbc:	48 c1 e9 03          	shr    $0x3,%rcx
  800fc0:	fd                   	std
  800fc1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800fc4:	fc                   	cld
  800fc5:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800fc6:	48 83 ef 01          	sub    $0x1,%rdi
  800fca:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800fce:	fd                   	std
  800fcf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800fd1:	eb f1                	jmp    800fc4 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800fd3:	48 89 f2             	mov    %rsi,%rdx
  800fd6:	48 09 c2             	or     %rax,%rdx
  800fd9:	48 09 ca             	or     %rcx,%rdx
  800fdc:	f6 c2 07             	test   $0x7,%dl
  800fdf:	75 0c                	jne    800fed <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800fe1:	48 c1 e9 03          	shr    $0x3,%rcx
  800fe5:	48 89 c7             	mov    %rax,%rdi
  800fe8:	fc                   	cld
  800fe9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800fec:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800fed:	48 89 c7             	mov    %rax,%rdi
  800ff0:	fc                   	cld
  800ff1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ff3:	c3                   	ret

0000000000800ff4 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800ff4:	f3 0f 1e fa          	endbr64
  800ff8:	55                   	push   %rbp
  800ff9:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800ffc:	48 b8 89 0f 80 00 00 	movabs $0x800f89,%rax
  801003:	00 00 00 
  801006:	ff d0                	call   *%rax
}
  801008:	5d                   	pop    %rbp
  801009:	c3                   	ret

000000000080100a <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80100a:	f3 0f 1e fa          	endbr64
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	41 57                	push   %r15
  801014:	41 56                	push   %r14
  801016:	41 55                	push   %r13
  801018:	41 54                	push   %r12
  80101a:	53                   	push   %rbx
  80101b:	48 83 ec 08          	sub    $0x8,%rsp
  80101f:	49 89 fe             	mov    %rdi,%r14
  801022:	49 89 f7             	mov    %rsi,%r15
  801025:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801028:	48 89 f7             	mov    %rsi,%rdi
  80102b:	48 b8 29 0d 80 00 00 	movabs $0x800d29,%rax
  801032:	00 00 00 
  801035:	ff d0                	call   *%rax
  801037:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80103a:	48 89 de             	mov    %rbx,%rsi
  80103d:	4c 89 f7             	mov    %r14,%rdi
  801040:	48 b8 48 0d 80 00 00 	movabs $0x800d48,%rax
  801047:	00 00 00 
  80104a:	ff d0                	call   *%rax
  80104c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80104f:	48 39 c3             	cmp    %rax,%rbx
  801052:	74 36                	je     80108a <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801054:	48 89 d8             	mov    %rbx,%rax
  801057:	4c 29 e8             	sub    %r13,%rax
  80105a:	49 39 c4             	cmp    %rax,%r12
  80105d:	73 31                	jae    801090 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80105f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801064:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801068:	4c 89 fe             	mov    %r15,%rsi
  80106b:	48 b8 f4 0f 80 00 00 	movabs $0x800ff4,%rax
  801072:	00 00 00 
  801075:	ff d0                	call   *%rax
    return dstlen + srclen;
  801077:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80107b:	48 83 c4 08          	add    $0x8,%rsp
  80107f:	5b                   	pop    %rbx
  801080:	41 5c                	pop    %r12
  801082:	41 5d                	pop    %r13
  801084:	41 5e                	pop    %r14
  801086:	41 5f                	pop    %r15
  801088:	5d                   	pop    %rbp
  801089:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80108a:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80108e:	eb eb                	jmp    80107b <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801090:	48 83 eb 01          	sub    $0x1,%rbx
  801094:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801098:	48 89 da             	mov    %rbx,%rdx
  80109b:	4c 89 fe             	mov    %r15,%rsi
  80109e:	48 b8 f4 0f 80 00 00 	movabs $0x800ff4,%rax
  8010a5:	00 00 00 
  8010a8:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8010aa:	49 01 de             	add    %rbx,%r14
  8010ad:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8010b2:	eb c3                	jmp    801077 <strlcat+0x6d>

00000000008010b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8010b4:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8010b8:	48 85 d2             	test   %rdx,%rdx
  8010bb:	74 2d                	je     8010ea <memcmp+0x36>
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8010c2:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8010c6:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8010cb:	44 38 c1             	cmp    %r8b,%cl
  8010ce:	75 0f                	jne    8010df <memcmp+0x2b>
    while (n-- > 0) {
  8010d0:	48 83 c0 01          	add    $0x1,%rax
  8010d4:	48 39 c2             	cmp    %rax,%rdx
  8010d7:	75 e9                	jne    8010c2 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010de:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8010df:	0f b6 c1             	movzbl %cl,%eax
  8010e2:	45 0f b6 c0          	movzbl %r8b,%r8d
  8010e6:	44 29 c0             	sub    %r8d,%eax
  8010e9:	c3                   	ret
    return 0;
  8010ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ef:	c3                   	ret

00000000008010f0 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8010f0:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8010f4:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8010f8:	48 39 c7             	cmp    %rax,%rdi
  8010fb:	73 0f                	jae    80110c <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010fd:	40 38 37             	cmp    %sil,(%rdi)
  801100:	74 0e                	je     801110 <memfind+0x20>
    for (; src < end; src++) {
  801102:	48 83 c7 01          	add    $0x1,%rdi
  801106:	48 39 f8             	cmp    %rdi,%rax
  801109:	75 f2                	jne    8010fd <memfind+0xd>
  80110b:	c3                   	ret
  80110c:	48 89 f8             	mov    %rdi,%rax
  80110f:	c3                   	ret
  801110:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801113:	c3                   	ret

0000000000801114 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801114:	f3 0f 1e fa          	endbr64
  801118:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80111b:	0f b6 37             	movzbl (%rdi),%esi
  80111e:	40 80 fe 20          	cmp    $0x20,%sil
  801122:	74 06                	je     80112a <strtol+0x16>
  801124:	40 80 fe 09          	cmp    $0x9,%sil
  801128:	75 13                	jne    80113d <strtol+0x29>
  80112a:	48 83 c7 01          	add    $0x1,%rdi
  80112e:	0f b6 37             	movzbl (%rdi),%esi
  801131:	40 80 fe 20          	cmp    $0x20,%sil
  801135:	74 f3                	je     80112a <strtol+0x16>
  801137:	40 80 fe 09          	cmp    $0x9,%sil
  80113b:	74 ed                	je     80112a <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80113d:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801140:	83 e0 fd             	and    $0xfffffffd,%eax
  801143:	3c 01                	cmp    $0x1,%al
  801145:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801149:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80114f:	75 0f                	jne    801160 <strtol+0x4c>
  801151:	80 3f 30             	cmpb   $0x30,(%rdi)
  801154:	74 14                	je     80116a <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801156:	85 d2                	test   %edx,%edx
  801158:	b8 0a 00 00 00       	mov    $0xa,%eax
  80115d:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801160:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801165:	4c 63 ca             	movslq %edx,%r9
  801168:	eb 36                	jmp    8011a0 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80116a:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80116e:	74 0f                	je     80117f <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801170:	85 d2                	test   %edx,%edx
  801172:	75 ec                	jne    801160 <strtol+0x4c>
        s++;
  801174:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801178:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80117d:	eb e1                	jmp    801160 <strtol+0x4c>
        s += 2;
  80117f:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801183:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801188:	eb d6                	jmp    801160 <strtol+0x4c>
            dig -= '0';
  80118a:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80118d:	44 0f b6 c1          	movzbl %cl,%r8d
  801191:	41 39 d0             	cmp    %edx,%r8d
  801194:	7d 21                	jge    8011b7 <strtol+0xa3>
        val = val * base + dig;
  801196:	49 0f af c1          	imul   %r9,%rax
  80119a:	0f b6 c9             	movzbl %cl,%ecx
  80119d:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8011a0:	48 83 c7 01          	add    $0x1,%rdi
  8011a4:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8011a8:	80 f9 39             	cmp    $0x39,%cl
  8011ab:	76 dd                	jbe    80118a <strtol+0x76>
        else if (dig - 'a' < 27)
  8011ad:	80 f9 7b             	cmp    $0x7b,%cl
  8011b0:	77 05                	ja     8011b7 <strtol+0xa3>
            dig -= 'a' - 10;
  8011b2:	83 e9 57             	sub    $0x57,%ecx
  8011b5:	eb d6                	jmp    80118d <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8011b7:	4d 85 d2             	test   %r10,%r10
  8011ba:	74 03                	je     8011bf <strtol+0xab>
  8011bc:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8011bf:	48 89 c2             	mov    %rax,%rdx
  8011c2:	48 f7 da             	neg    %rdx
  8011c5:	40 80 fe 2d          	cmp    $0x2d,%sil
  8011c9:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8011cd:	c3                   	ret

00000000008011ce <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8011ce:	f3 0f 1e fa          	endbr64
  8011d2:	55                   	push   %rbp
  8011d3:	48 89 e5             	mov    %rsp,%rbp
  8011d6:	53                   	push   %rbx
  8011d7:	48 89 fa             	mov    %rdi,%rdx
  8011da:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ec:	be 00 00 00 00       	mov    $0x0,%esi
  8011f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f7:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8011f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011fd:	c9                   	leave
  8011fe:	c3                   	ret

00000000008011ff <sys_cgetc>:

int
sys_cgetc(void) {
  8011ff:	f3 0f 1e fa          	endbr64
  801203:	55                   	push   %rbp
  801204:	48 89 e5             	mov    %rsp,%rbp
  801207:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801208:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80120d:	ba 00 00 00 00       	mov    $0x0,%edx
  801212:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801217:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801221:	be 00 00 00 00       	mov    $0x0,%esi
  801226:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80122c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80122e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801232:	c9                   	leave
  801233:	c3                   	ret

0000000000801234 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801234:	f3 0f 1e fa          	endbr64
  801238:	55                   	push   %rbp
  801239:	48 89 e5             	mov    %rsp,%rbp
  80123c:	53                   	push   %rbx
  80123d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801241:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801244:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801249:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80124e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801253:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801258:	be 00 00 00 00       	mov    $0x0,%esi
  80125d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801263:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801265:	48 85 c0             	test   %rax,%rax
  801268:	7f 06                	jg     801270 <sys_env_destroy+0x3c>
}
  80126a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80126e:	c9                   	leave
  80126f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801270:	49 89 c0             	mov    %rax,%r8
  801273:	b9 03 00 00 00       	mov    $0x3,%ecx
  801278:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  80127f:	00 00 00 
  801282:	be 26 00 00 00       	mov    $0x26,%esi
  801287:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  80128e:	00 00 00 
  801291:	b8 00 00 00 00       	mov    $0x0,%eax
  801296:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  80129d:	00 00 00 
  8012a0:	41 ff d1             	call   *%r9

00000000008012a3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8012a3:	f3 0f 1e fa          	endbr64
  8012a7:	55                   	push   %rbp
  8012a8:	48 89 e5             	mov    %rsp,%rbp
  8012ab:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012ac:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c5:	be 00 00 00 00       	mov    $0x0,%esi
  8012ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012d0:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8012d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012d6:	c9                   	leave
  8012d7:	c3                   	ret

00000000008012d8 <sys_yield>:

void
sys_yield(void) {
  8012d8:	f3 0f 1e fa          	endbr64
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012e1:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012eb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012fa:	be 00 00 00 00       	mov    $0x0,%esi
  8012ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801305:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801307:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130b:	c9                   	leave
  80130c:	c3                   	ret

000000000080130d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80130d:	f3 0f 1e fa          	endbr64
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	53                   	push   %rbx
  801316:	48 89 fa             	mov    %rdi,%rdx
  801319:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80131c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801321:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801328:	00 00 00 
  80132b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801330:	be 00 00 00 00       	mov    $0x0,%esi
  801335:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80133b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80133d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801341:	c9                   	leave
  801342:	c3                   	ret

0000000000801343 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801343:	f3 0f 1e fa          	endbr64
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	53                   	push   %rbx
  80134c:	49 89 f8             	mov    %rdi,%r8
  80134f:	48 89 d3             	mov    %rdx,%rbx
  801352:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801355:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80135a:	4c 89 c2             	mov    %r8,%rdx
  80135d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801360:	be 00 00 00 00       	mov    $0x0,%esi
  801365:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80136b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80136d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801371:	c9                   	leave
  801372:	c3                   	ret

0000000000801373 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801373:	f3 0f 1e fa          	endbr64
  801377:	55                   	push   %rbp
  801378:	48 89 e5             	mov    %rsp,%rbp
  80137b:	53                   	push   %rbx
  80137c:	48 83 ec 08          	sub    $0x8,%rsp
  801380:	89 f8                	mov    %edi,%eax
  801382:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801385:	48 63 f9             	movslq %ecx,%rdi
  801388:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80138b:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801390:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801393:	be 00 00 00 00       	mov    $0x0,%esi
  801398:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80139e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013a0:	48 85 c0             	test   %rax,%rax
  8013a3:	7f 06                	jg     8013ab <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8013a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a9:	c9                   	leave
  8013aa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ab:	49 89 c0             	mov    %rax,%r8
  8013ae:	b9 04 00 00 00       	mov    $0x4,%ecx
  8013b3:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  8013ba:	00 00 00 
  8013bd:	be 26 00 00 00       	mov    $0x26,%esi
  8013c2:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  8013c9:	00 00 00 
  8013cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d1:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  8013d8:	00 00 00 
  8013db:	41 ff d1             	call   *%r9

00000000008013de <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013de:	f3 0f 1e fa          	endbr64
  8013e2:	55                   	push   %rbp
  8013e3:	48 89 e5             	mov    %rsp,%rbp
  8013e6:	53                   	push   %rbx
  8013e7:	48 83 ec 08          	sub    $0x8,%rsp
  8013eb:	89 f8                	mov    %edi,%eax
  8013ed:	49 89 f2             	mov    %rsi,%r10
  8013f0:	48 89 cf             	mov    %rcx,%rdi
  8013f3:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8013f6:	48 63 da             	movslq %edx,%rbx
  8013f9:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013fc:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801401:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801404:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801407:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801409:	48 85 c0             	test   %rax,%rax
  80140c:	7f 06                	jg     801414 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80140e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801412:	c9                   	leave
  801413:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801414:	49 89 c0             	mov    %rax,%r8
  801417:	b9 05 00 00 00       	mov    $0x5,%ecx
  80141c:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  801423:	00 00 00 
  801426:	be 26 00 00 00       	mov    $0x26,%esi
  80142b:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  801432:	00 00 00 
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
  80143a:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  801441:	00 00 00 
  801444:	41 ff d1             	call   *%r9

0000000000801447 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801447:	f3 0f 1e fa          	endbr64
  80144b:	55                   	push   %rbp
  80144c:	48 89 e5             	mov    %rsp,%rbp
  80144f:	53                   	push   %rbx
  801450:	48 83 ec 08          	sub    $0x8,%rsp
  801454:	49 89 f9             	mov    %rdi,%r9
  801457:	89 f0                	mov    %esi,%eax
  801459:	48 89 d3             	mov    %rdx,%rbx
  80145c:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80145f:	49 63 f0             	movslq %r8d,%rsi
  801462:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801465:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80146a:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80146d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801473:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801475:	48 85 c0             	test   %rax,%rax
  801478:	7f 06                	jg     801480 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80147a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80147e:	c9                   	leave
  80147f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801480:	49 89 c0             	mov    %rax,%r8
  801483:	b9 06 00 00 00       	mov    $0x6,%ecx
  801488:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  80148f:	00 00 00 
  801492:	be 26 00 00 00       	mov    $0x26,%esi
  801497:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  80149e:	00 00 00 
  8014a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a6:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  8014ad:	00 00 00 
  8014b0:	41 ff d1             	call   *%r9

00000000008014b3 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8014b3:	f3 0f 1e fa          	endbr64
  8014b7:	55                   	push   %rbp
  8014b8:	48 89 e5             	mov    %rsp,%rbp
  8014bb:	53                   	push   %rbx
  8014bc:	48 83 ec 08          	sub    $0x8,%rsp
  8014c0:	48 89 f1             	mov    %rsi,%rcx
  8014c3:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8014c6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014c9:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ce:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014d3:	be 00 00 00 00       	mov    $0x0,%esi
  8014d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014de:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014e0:	48 85 c0             	test   %rax,%rax
  8014e3:	7f 06                	jg     8014eb <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8014e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e9:	c9                   	leave
  8014ea:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014eb:	49 89 c0             	mov    %rax,%r8
  8014ee:	b9 07 00 00 00       	mov    $0x7,%ecx
  8014f3:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  8014fa:	00 00 00 
  8014fd:	be 26 00 00 00       	mov    $0x26,%esi
  801502:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  801509:	00 00 00 
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  801518:	00 00 00 
  80151b:	41 ff d1             	call   *%r9

000000000080151e <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80151e:	f3 0f 1e fa          	endbr64
  801522:	55                   	push   %rbp
  801523:	48 89 e5             	mov    %rsp,%rbp
  801526:	53                   	push   %rbx
  801527:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80152b:	48 63 ce             	movslq %esi,%rcx
  80152e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801531:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801536:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801540:	be 00 00 00 00       	mov    $0x0,%esi
  801545:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80154d:	48 85 c0             	test   %rax,%rax
  801550:	7f 06                	jg     801558 <sys_env_set_status+0x3a>
}
  801552:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801556:	c9                   	leave
  801557:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801558:	49 89 c0             	mov    %rax,%r8
  80155b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801560:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  801567:	00 00 00 
  80156a:	be 26 00 00 00       	mov    $0x26,%esi
  80156f:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  801576:	00 00 00 
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
  80157e:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  801585:	00 00 00 
  801588:	41 ff d1             	call   *%r9

000000000080158b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80158b:	f3 0f 1e fa          	endbr64
  80158f:	55                   	push   %rbp
  801590:	48 89 e5             	mov    %rsp,%rbp
  801593:	53                   	push   %rbx
  801594:	48 83 ec 08          	sub    $0x8,%rsp
  801598:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80159b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80159e:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ad:	be 00 00 00 00       	mov    $0x0,%esi
  8015b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015b8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015ba:	48 85 c0             	test   %rax,%rax
  8015bd:	7f 06                	jg     8015c5 <sys_env_set_trapframe+0x3a>
}
  8015bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015c3:	c9                   	leave
  8015c4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015c5:	49 89 c0             	mov    %rax,%r8
  8015c8:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8015cd:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  8015d4:	00 00 00 
  8015d7:	be 26 00 00 00       	mov    $0x26,%esi
  8015dc:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  8015e3:	00 00 00 
  8015e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015eb:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  8015f2:	00 00 00 
  8015f5:	41 ff d1             	call   *%r9

00000000008015f8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8015f8:	f3 0f 1e fa          	endbr64
  8015fc:	55                   	push   %rbp
  8015fd:	48 89 e5             	mov    %rsp,%rbp
  801600:	53                   	push   %rbx
  801601:	48 83 ec 08          	sub    $0x8,%rsp
  801605:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801608:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80160b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801610:	bb 00 00 00 00       	mov    $0x0,%ebx
  801615:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80161a:	be 00 00 00 00       	mov    $0x0,%esi
  80161f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801625:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801627:	48 85 c0             	test   %rax,%rax
  80162a:	7f 06                	jg     801632 <sys_env_set_pgfault_upcall+0x3a>
}
  80162c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801630:	c9                   	leave
  801631:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801632:	49 89 c0             	mov    %rax,%r8
  801635:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80163a:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  801641:	00 00 00 
  801644:	be 26 00 00 00       	mov    $0x26,%esi
  801649:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  801650:	00 00 00 
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  80165f:	00 00 00 
  801662:	41 ff d1             	call   *%r9

0000000000801665 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801665:	f3 0f 1e fa          	endbr64
  801669:	55                   	push   %rbp
  80166a:	48 89 e5             	mov    %rsp,%rbp
  80166d:	53                   	push   %rbx
  80166e:	89 f8                	mov    %edi,%eax
  801670:	49 89 f1             	mov    %rsi,%r9
  801673:	48 89 d3             	mov    %rdx,%rbx
  801676:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801679:	49 63 f0             	movslq %r8d,%rsi
  80167c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80167f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801684:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801687:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80168d:	cd 30                	int    $0x30
}
  80168f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801693:	c9                   	leave
  801694:	c3                   	ret

0000000000801695 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801695:	f3 0f 1e fa          	endbr64
  801699:	55                   	push   %rbp
  80169a:	48 89 e5             	mov    %rsp,%rbp
  80169d:	53                   	push   %rbx
  80169e:	48 83 ec 08          	sub    $0x8,%rsp
  8016a2:	48 89 fa             	mov    %rdi,%rdx
  8016a5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016a8:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b7:	be 00 00 00 00       	mov    $0x0,%esi
  8016bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016c2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016c4:	48 85 c0             	test   %rax,%rax
  8016c7:	7f 06                	jg     8016cf <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8016c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016cd:	c9                   	leave
  8016ce:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016cf:	49 89 c0             	mov    %rax,%r8
  8016d2:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8016d7:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  8016de:	00 00 00 
  8016e1:	be 26 00 00 00       	mov    $0x26,%esi
  8016e6:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  8016ed:	00 00 00 
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f5:	49 b9 c9 02 80 00 00 	movabs $0x8002c9,%r9
  8016fc:	00 00 00 
  8016ff:	41 ff d1             	call   *%r9

0000000000801702 <sys_gettime>:

int
sys_gettime(void) {
  801702:	f3 0f 1e fa          	endbr64
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80170b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801710:	ba 00 00 00 00       	mov    $0x0,%edx
  801715:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80171a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80171f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801724:	be 00 00 00 00       	mov    $0x0,%esi
  801729:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80172f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801731:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801735:	c9                   	leave
  801736:	c3                   	ret

0000000000801737 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801737:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80173b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801742:	ff ff ff 
  801745:	48 01 f8             	add    %rdi,%rax
  801748:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80174c:	c3                   	ret

000000000080174d <fd2data>:

char *
fd2data(struct Fd *fd) {
  80174d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801751:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801758:	ff ff ff 
  80175b:	48 01 f8             	add    %rdi,%rax
  80175e:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801762:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801768:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80176c:	c3                   	ret

000000000080176d <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80176d:	f3 0f 1e fa          	endbr64
  801771:	55                   	push   %rbp
  801772:	48 89 e5             	mov    %rsp,%rbp
  801775:	41 57                	push   %r15
  801777:	41 56                	push   %r14
  801779:	41 55                	push   %r13
  80177b:	41 54                	push   %r12
  80177d:	53                   	push   %rbx
  80177e:	48 83 ec 08          	sub    $0x8,%rsp
  801782:	49 89 ff             	mov    %rdi,%r15
  801785:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80178a:	49 bd 54 31 80 00 00 	movabs $0x803154,%r13
  801791:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801794:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80179a:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80179d:	48 89 df             	mov    %rbx,%rdi
  8017a0:	41 ff d5             	call   *%r13
  8017a3:	83 e0 04             	and    $0x4,%eax
  8017a6:	74 17                	je     8017bf <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8017a8:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8017af:	4c 39 f3             	cmp    %r14,%rbx
  8017b2:	75 e6                	jne    80179a <fd_alloc+0x2d>
  8017b4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8017ba:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8017bf:	4d 89 27             	mov    %r12,(%r15)
}
  8017c2:	48 83 c4 08          	add    $0x8,%rsp
  8017c6:	5b                   	pop    %rbx
  8017c7:	41 5c                	pop    %r12
  8017c9:	41 5d                	pop    %r13
  8017cb:	41 5e                	pop    %r14
  8017cd:	41 5f                	pop    %r15
  8017cf:	5d                   	pop    %rbp
  8017d0:	c3                   	ret

00000000008017d1 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017d1:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8017d5:	83 ff 1f             	cmp    $0x1f,%edi
  8017d8:	77 39                	ja     801813 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	41 54                	push   %r12
  8017e0:	53                   	push   %rbx
  8017e1:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8017e4:	48 63 df             	movslq %edi,%rbx
  8017e7:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8017ee:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8017f2:	48 89 df             	mov    %rbx,%rdi
  8017f5:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  8017fc:	00 00 00 
  8017ff:	ff d0                	call   *%rax
  801801:	a8 04                	test   $0x4,%al
  801803:	74 14                	je     801819 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801805:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180e:	5b                   	pop    %rbx
  80180f:	41 5c                	pop    %r12
  801811:	5d                   	pop    %rbp
  801812:	c3                   	ret
        return -E_INVAL;
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801818:	c3                   	ret
        return -E_INVAL;
  801819:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181e:	eb ee                	jmp    80180e <fd_lookup+0x3d>

0000000000801820 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801820:	f3 0f 1e fa          	endbr64
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	41 54                	push   %r12
  80182a:	53                   	push   %rbx
  80182b:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80182e:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  801835:	00 00 00 
  801838:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  80183f:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801842:	39 3b                	cmp    %edi,(%rbx)
  801844:	74 47                	je     80188d <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801846:	48 83 c0 08          	add    $0x8,%rax
  80184a:	48 8b 18             	mov    (%rax),%rbx
  80184d:	48 85 db             	test   %rbx,%rbx
  801850:	75 f0                	jne    801842 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801852:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801859:	00 00 00 
  80185c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801862:	89 fa                	mov    %edi,%edx
  801864:	48 bf f8 43 80 00 00 	movabs $0x8043f8,%rdi
  80186b:	00 00 00 
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  80187a:	00 00 00 
  80187d:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80187f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801884:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801888:	5b                   	pop    %rbx
  801889:	41 5c                	pop    %r12
  80188b:	5d                   	pop    %rbp
  80188c:	c3                   	ret
            return 0;
  80188d:	b8 00 00 00 00       	mov    $0x0,%eax
  801892:	eb f0                	jmp    801884 <dev_lookup+0x64>

0000000000801894 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801894:	f3 0f 1e fa          	endbr64
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	41 55                	push   %r13
  80189e:	41 54                	push   %r12
  8018a0:	53                   	push   %rbx
  8018a1:	48 83 ec 18          	sub    $0x18,%rsp
  8018a5:	48 89 fb             	mov    %rdi,%rbx
  8018a8:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018ab:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8018b2:	ff ff ff 
  8018b5:	48 01 df             	add    %rbx,%rdi
  8018b8:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8018bc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018c0:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  8018c7:	00 00 00 
  8018ca:	ff d0                	call   *%rax
  8018cc:	41 89 c5             	mov    %eax,%r13d
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 06                	js     8018d9 <fd_close+0x45>
  8018d3:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8018d7:	74 1a                	je     8018f3 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8018d9:	45 84 e4             	test   %r12b,%r12b
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e1:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8018e5:	44 89 e8             	mov    %r13d,%eax
  8018e8:	48 83 c4 18          	add    $0x18,%rsp
  8018ec:	5b                   	pop    %rbx
  8018ed:	41 5c                	pop    %r12
  8018ef:	41 5d                	pop    %r13
  8018f1:	5d                   	pop    %rbp
  8018f2:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f3:	8b 3b                	mov    (%rbx),%edi
  8018f5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018f9:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801900:	00 00 00 
  801903:	ff d0                	call   *%rax
  801905:	41 89 c5             	mov    %eax,%r13d
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 1b                	js     801927 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80190c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801910:	48 8b 40 20          	mov    0x20(%rax),%rax
  801914:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80191a:	48 85 c0             	test   %rax,%rax
  80191d:	74 08                	je     801927 <fd_close+0x93>
  80191f:	48 89 df             	mov    %rbx,%rdi
  801922:	ff d0                	call   *%rax
  801924:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801927:	ba 00 10 00 00       	mov    $0x1000,%edx
  80192c:	48 89 de             	mov    %rbx,%rsi
  80192f:	bf 00 00 00 00       	mov    $0x0,%edi
  801934:	48 b8 b3 14 80 00 00 	movabs $0x8014b3,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	call   *%rax
    return res;
  801940:	eb a3                	jmp    8018e5 <fd_close+0x51>

0000000000801942 <close>:

int
close(int fdnum) {
  801942:	f3 0f 1e fa          	endbr64
  801946:	55                   	push   %rbp
  801947:	48 89 e5             	mov    %rsp,%rbp
  80194a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80194e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801952:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801959:	00 00 00 
  80195c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 15                	js     801977 <close+0x35>

    return fd_close(fd, 1);
  801962:	be 01 00 00 00       	mov    $0x1,%esi
  801967:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80196b:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  801972:	00 00 00 
  801975:	ff d0                	call   *%rax
}
  801977:	c9                   	leave
  801978:	c3                   	ret

0000000000801979 <close_all>:

void
close_all(void) {
  801979:	f3 0f 1e fa          	endbr64
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	41 54                	push   %r12
  801983:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801984:	bb 00 00 00 00       	mov    $0x0,%ebx
  801989:	49 bc 42 19 80 00 00 	movabs $0x801942,%r12
  801990:	00 00 00 
  801993:	89 df                	mov    %ebx,%edi
  801995:	41 ff d4             	call   *%r12
  801998:	83 c3 01             	add    $0x1,%ebx
  80199b:	83 fb 20             	cmp    $0x20,%ebx
  80199e:	75 f3                	jne    801993 <close_all+0x1a>
}
  8019a0:	5b                   	pop    %rbx
  8019a1:	41 5c                	pop    %r12
  8019a3:	5d                   	pop    %rbp
  8019a4:	c3                   	ret

00000000008019a5 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8019a5:	f3 0f 1e fa          	endbr64
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	41 57                	push   %r15
  8019af:	41 56                	push   %r14
  8019b1:	41 55                	push   %r13
  8019b3:	41 54                	push   %r12
  8019b5:	53                   	push   %rbx
  8019b6:	48 83 ec 18          	sub    $0x18,%rsp
  8019ba:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8019bd:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8019c1:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  8019c8:	00 00 00 
  8019cb:	ff d0                	call   *%rax
  8019cd:	89 c3                	mov    %eax,%ebx
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	0f 88 b8 00 00 00    	js     801a8f <dup+0xea>
    close(newfdnum);
  8019d7:	44 89 e7             	mov    %r12d,%edi
  8019da:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8019e6:	4d 63 ec             	movslq %r12d,%r13
  8019e9:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8019f0:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8019f4:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8019f8:	4c 89 ff             	mov    %r15,%rdi
  8019fb:	49 be 4d 17 80 00 00 	movabs $0x80174d,%r14
  801a02:	00 00 00 
  801a05:	41 ff d6             	call   *%r14
  801a08:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a0b:	4c 89 ef             	mov    %r13,%rdi
  801a0e:	41 ff d6             	call   *%r14
  801a11:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a14:	48 89 df             	mov    %rbx,%rdi
  801a17:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  801a1e:	00 00 00 
  801a21:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a23:	a8 04                	test   $0x4,%al
  801a25:	74 2b                	je     801a52 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a27:	41 89 c1             	mov    %eax,%r9d
  801a2a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a30:	4c 89 f1             	mov    %r14,%rcx
  801a33:	ba 00 00 00 00       	mov    $0x0,%edx
  801a38:	48 89 de             	mov    %rbx,%rsi
  801a3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a40:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  801a47:	00 00 00 
  801a4a:	ff d0                	call   *%rax
  801a4c:	89 c3                	mov    %eax,%ebx
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 4e                	js     801aa0 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801a52:	4c 89 ff             	mov    %r15,%rdi
  801a55:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  801a5c:	00 00 00 
  801a5f:	ff d0                	call   *%rax
  801a61:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a64:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a6a:	4c 89 e9             	mov    %r13,%rcx
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	4c 89 fe             	mov    %r15,%rsi
  801a75:	bf 00 00 00 00       	mov    $0x0,%edi
  801a7a:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	call   *%rax
  801a86:	89 c3                	mov    %eax,%ebx
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 14                	js     801aa0 <dup+0xfb>

    return newfdnum;
  801a8c:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	48 83 c4 18          	add    $0x18,%rsp
  801a95:	5b                   	pop    %rbx
  801a96:	41 5c                	pop    %r12
  801a98:	41 5d                	pop    %r13
  801a9a:	41 5e                	pop    %r14
  801a9c:	41 5f                	pop    %r15
  801a9e:	5d                   	pop    %rbp
  801a9f:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801aa0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aa5:	4c 89 ee             	mov    %r13,%rsi
  801aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  801aad:	49 bc b3 14 80 00 00 	movabs $0x8014b3,%r12
  801ab4:	00 00 00 
  801ab7:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801aba:	ba 00 10 00 00       	mov    $0x1000,%edx
  801abf:	4c 89 f6             	mov    %r14,%rsi
  801ac2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ac7:	41 ff d4             	call   *%r12
    return res;
  801aca:	eb c3                	jmp    801a8f <dup+0xea>

0000000000801acc <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801acc:	f3 0f 1e fa          	endbr64
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	41 56                	push   %r14
  801ad6:	41 55                	push   %r13
  801ad8:	41 54                	push   %r12
  801ada:	53                   	push   %rbx
  801adb:	48 83 ec 10          	sub    $0x10,%rsp
  801adf:	89 fb                	mov    %edi,%ebx
  801ae1:	49 89 f4             	mov    %rsi,%r12
  801ae4:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ae7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aeb:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801af2:	00 00 00 
  801af5:	ff d0                	call   *%rax
  801af7:	85 c0                	test   %eax,%eax
  801af9:	78 4c                	js     801b47 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801afb:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801aff:	41 8b 3e             	mov    (%r14),%edi
  801b02:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b06:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	call   *%rax
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 35                	js     801b4b <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b16:	41 8b 46 08          	mov    0x8(%r14),%eax
  801b1a:	83 e0 03             	and    $0x3,%eax
  801b1d:	83 f8 01             	cmp    $0x1,%eax
  801b20:	74 2d                	je     801b4f <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b26:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b2a:	48 85 c0             	test   %rax,%rax
  801b2d:	74 56                	je     801b85 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801b2f:	4c 89 ea             	mov    %r13,%rdx
  801b32:	4c 89 e6             	mov    %r12,%rsi
  801b35:	4c 89 f7             	mov    %r14,%rdi
  801b38:	ff d0                	call   *%rax
}
  801b3a:	48 83 c4 10          	add    $0x10,%rsp
  801b3e:	5b                   	pop    %rbx
  801b3f:	41 5c                	pop    %r12
  801b41:	41 5d                	pop    %r13
  801b43:	41 5e                	pop    %r14
  801b45:	5d                   	pop    %rbp
  801b46:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b47:	48 98                	cltq
  801b49:	eb ef                	jmp    801b3a <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b4b:	48 98                	cltq
  801b4d:	eb eb                	jmp    801b3a <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b4f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b56:	00 00 00 
  801b59:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b5f:	89 da                	mov    %ebx,%edx
  801b61:	48 bf 72 42 80 00 00 	movabs $0x804272,%rdi
  801b68:	00 00 00 
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b70:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  801b77:	00 00 00 
  801b7a:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b7c:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b83:	eb b5                	jmp    801b3a <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b85:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b8c:	eb ac                	jmp    801b3a <read+0x6e>

0000000000801b8e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b8e:	f3 0f 1e fa          	endbr64
  801b92:	55                   	push   %rbp
  801b93:	48 89 e5             	mov    %rsp,%rbp
  801b96:	41 57                	push   %r15
  801b98:	41 56                	push   %r14
  801b9a:	41 55                	push   %r13
  801b9c:	41 54                	push   %r12
  801b9e:	53                   	push   %rbx
  801b9f:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ba3:	48 85 d2             	test   %rdx,%rdx
  801ba6:	74 54                	je     801bfc <readn+0x6e>
  801ba8:	41 89 fd             	mov    %edi,%r13d
  801bab:	49 89 f6             	mov    %rsi,%r14
  801bae:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801bb1:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801bb6:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801bbb:	49 bf cc 1a 80 00 00 	movabs $0x801acc,%r15
  801bc2:	00 00 00 
  801bc5:	4c 89 e2             	mov    %r12,%rdx
  801bc8:	48 29 f2             	sub    %rsi,%rdx
  801bcb:	4c 01 f6             	add    %r14,%rsi
  801bce:	44 89 ef             	mov    %r13d,%edi
  801bd1:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	78 20                	js     801bf8 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801bd8:	01 c3                	add    %eax,%ebx
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	74 08                	je     801be6 <readn+0x58>
  801bde:	48 63 f3             	movslq %ebx,%rsi
  801be1:	4c 39 e6             	cmp    %r12,%rsi
  801be4:	72 df                	jb     801bc5 <readn+0x37>
    }
    return res;
  801be6:	48 63 c3             	movslq %ebx,%rax
}
  801be9:	48 83 c4 08          	add    $0x8,%rsp
  801bed:	5b                   	pop    %rbx
  801bee:	41 5c                	pop    %r12
  801bf0:	41 5d                	pop    %r13
  801bf2:	41 5e                	pop    %r14
  801bf4:	41 5f                	pop    %r15
  801bf6:	5d                   	pop    %rbp
  801bf7:	c3                   	ret
        if (inc < 0) return inc;
  801bf8:	48 98                	cltq
  801bfa:	eb ed                	jmp    801be9 <readn+0x5b>
    int inc = 1, res = 0;
  801bfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c01:	eb e3                	jmp    801be6 <readn+0x58>

0000000000801c03 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801c03:	f3 0f 1e fa          	endbr64
  801c07:	55                   	push   %rbp
  801c08:	48 89 e5             	mov    %rsp,%rbp
  801c0b:	41 56                	push   %r14
  801c0d:	41 55                	push   %r13
  801c0f:	41 54                	push   %r12
  801c11:	53                   	push   %rbx
  801c12:	48 83 ec 10          	sub    $0x10,%rsp
  801c16:	89 fb                	mov    %edi,%ebx
  801c18:	49 89 f4             	mov    %rsi,%r12
  801c1b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c1e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c22:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801c29:	00 00 00 
  801c2c:	ff d0                	call   *%rax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 47                	js     801c79 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c32:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c36:	41 8b 3e             	mov    (%r14),%edi
  801c39:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c3d:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801c44:	00 00 00 
  801c47:	ff d0                	call   *%rax
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	78 30                	js     801c7d <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c4d:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801c52:	74 2d                	je     801c81 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c58:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c5c:	48 85 c0             	test   %rax,%rax
  801c5f:	74 56                	je     801cb7 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801c61:	4c 89 ea             	mov    %r13,%rdx
  801c64:	4c 89 e6             	mov    %r12,%rsi
  801c67:	4c 89 f7             	mov    %r14,%rdi
  801c6a:	ff d0                	call   *%rax
}
  801c6c:	48 83 c4 10          	add    $0x10,%rsp
  801c70:	5b                   	pop    %rbx
  801c71:	41 5c                	pop    %r12
  801c73:	41 5d                	pop    %r13
  801c75:	41 5e                	pop    %r14
  801c77:	5d                   	pop    %rbp
  801c78:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c79:	48 98                	cltq
  801c7b:	eb ef                	jmp    801c6c <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c7d:	48 98                	cltq
  801c7f:	eb eb                	jmp    801c6c <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c81:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c88:	00 00 00 
  801c8b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c91:	89 da                	mov    %ebx,%edx
  801c93:	48 bf 8e 42 80 00 00 	movabs $0x80428e,%rdi
  801c9a:	00 00 00 
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca2:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  801ca9:	00 00 00 
  801cac:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cae:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801cb5:	eb b5                	jmp    801c6c <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801cb7:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cbe:	eb ac                	jmp    801c6c <write+0x69>

0000000000801cc0 <seek>:

int
seek(int fdnum, off_t offset) {
  801cc0:	f3 0f 1e fa          	endbr64
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	53                   	push   %rbx
  801cc9:	48 83 ec 18          	sub    $0x18,%rsp
  801ccd:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ccf:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cd3:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	call   *%rax
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 0c                	js     801cef <seek+0x2f>

    fd->fd_offset = offset;
  801ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce7:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cf3:	c9                   	leave
  801cf4:	c3                   	ret

0000000000801cf5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801cf5:	f3 0f 1e fa          	endbr64
  801cf9:	55                   	push   %rbp
  801cfa:	48 89 e5             	mov    %rsp,%rbp
  801cfd:	41 55                	push   %r13
  801cff:	41 54                	push   %r12
  801d01:	53                   	push   %rbx
  801d02:	48 83 ec 18          	sub    $0x18,%rsp
  801d06:	89 fb                	mov    %edi,%ebx
  801d08:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d0b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d0f:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	call   *%rax
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 38                	js     801d57 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d1f:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801d23:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801d27:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d2b:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	call   *%rax
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 1c                	js     801d57 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d3b:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801d40:	74 20                	je     801d62 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d46:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d4a:	48 85 c0             	test   %rax,%rax
  801d4d:	74 47                	je     801d96 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801d4f:	44 89 e6             	mov    %r12d,%esi
  801d52:	4c 89 ef             	mov    %r13,%rdi
  801d55:	ff d0                	call   *%rax
}
  801d57:	48 83 c4 18          	add    $0x18,%rsp
  801d5b:	5b                   	pop    %rbx
  801d5c:	41 5c                	pop    %r12
  801d5e:	41 5d                	pop    %r13
  801d60:	5d                   	pop    %rbp
  801d61:	c3                   	ret
                thisenv->env_id, fdnum);
  801d62:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d69:	00 00 00 
  801d6c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d72:	89 da                	mov    %ebx,%edx
  801d74:	48 bf 20 44 80 00 00 	movabs $0x804420,%rdi
  801d7b:	00 00 00 
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d83:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  801d8a:	00 00 00 
  801d8d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d94:	eb c1                	jmp    801d57 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d96:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d9b:	eb ba                	jmp    801d57 <ftruncate+0x62>

0000000000801d9d <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d9d:	f3 0f 1e fa          	endbr64
  801da1:	55                   	push   %rbp
  801da2:	48 89 e5             	mov    %rsp,%rbp
  801da5:	41 54                	push   %r12
  801da7:	53                   	push   %rbx
  801da8:	48 83 ec 10          	sub    $0x10,%rsp
  801dac:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801daf:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801db3:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  801dba:	00 00 00 
  801dbd:	ff d0                	call   *%rax
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 4e                	js     801e11 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dc3:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801dc7:	41 8b 3c 24          	mov    (%r12),%edi
  801dcb:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801dcf:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801dd6:	00 00 00 
  801dd9:	ff d0                	call   *%rax
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	78 32                	js     801e11 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ddf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801de3:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801de8:	74 30                	je     801e1a <fstat+0x7d>

    stat->st_name[0] = 0;
  801dea:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ded:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801df4:	00 00 00 
    stat->st_isdir = 0;
  801df7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801dfe:	00 00 00 
    stat->st_dev = dev;
  801e01:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801e08:	48 89 de             	mov    %rbx,%rsi
  801e0b:	4c 89 e7             	mov    %r12,%rdi
  801e0e:	ff 50 28             	call   *0x28(%rax)
}
  801e11:	48 83 c4 10          	add    $0x10,%rsp
  801e15:	5b                   	pop    %rbx
  801e16:	41 5c                	pop    %r12
  801e18:	5d                   	pop    %rbp
  801e19:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e1a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e1f:	eb f0                	jmp    801e11 <fstat+0x74>

0000000000801e21 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e21:	f3 0f 1e fa          	endbr64
  801e25:	55                   	push   %rbp
  801e26:	48 89 e5             	mov    %rsp,%rbp
  801e29:	41 54                	push   %r12
  801e2b:	53                   	push   %rbx
  801e2c:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e2f:	be 00 00 00 00       	mov    $0x0,%esi
  801e34:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	call   *%rax
  801e40:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 25                	js     801e6b <stat+0x4a>

    int res = fstat(fd, stat);
  801e46:	4c 89 e6             	mov    %r12,%rsi
  801e49:	89 c7                	mov    %eax,%edi
  801e4b:	48 b8 9d 1d 80 00 00 	movabs $0x801d9d,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	call   *%rax
  801e57:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e5a:	89 df                	mov    %ebx,%edi
  801e5c:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	call   *%rax

    return res;
  801e68:	44 89 e3             	mov    %r12d,%ebx
}
  801e6b:	89 d8                	mov    %ebx,%eax
  801e6d:	5b                   	pop    %rbx
  801e6e:	41 5c                	pop    %r12
  801e70:	5d                   	pop    %rbp
  801e71:	c3                   	ret

0000000000801e72 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e72:	f3 0f 1e fa          	endbr64
  801e76:	55                   	push   %rbp
  801e77:	48 89 e5             	mov    %rsp,%rbp
  801e7a:	41 54                	push   %r12
  801e7c:	53                   	push   %rbx
  801e7d:	48 83 ec 10          	sub    $0x10,%rsp
  801e81:	41 89 fc             	mov    %edi,%r12d
  801e84:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e8e:	00 00 00 
  801e91:	83 38 00             	cmpl   $0x0,(%rax)
  801e94:	74 6e                	je     801f04 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801e96:	bf 03 00 00 00       	mov    $0x3,%edi
  801e9b:	48 b8 81 36 80 00 00 	movabs $0x803681,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	call   *%rax
  801ea7:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801eae:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801eb0:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801eb6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ebb:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801ec2:	00 00 00 
  801ec5:	44 89 e6             	mov    %r12d,%esi
  801ec8:	89 c7                	mov    %eax,%edi
  801eca:	48 b8 bf 35 80 00 00 	movabs $0x8035bf,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ed6:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801edd:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ee3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ee7:	48 89 de             	mov    %rbx,%rsi
  801eea:	bf 00 00 00 00       	mov    $0x0,%edi
  801eef:	48 b8 26 35 80 00 00 	movabs $0x803526,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	call   *%rax
}
  801efb:	48 83 c4 10          	add    $0x10,%rsp
  801eff:	5b                   	pop    %rbx
  801f00:	41 5c                	pop    %r12
  801f02:	5d                   	pop    %rbp
  801f03:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f04:	bf 03 00 00 00       	mov    $0x3,%edi
  801f09:	48 b8 81 36 80 00 00 	movabs $0x803681,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	call   *%rax
  801f15:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f1c:	00 00 
  801f1e:	e9 73 ff ff ff       	jmp    801e96 <fsipc+0x24>

0000000000801f23 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f23:	f3 0f 1e fa          	endbr64
  801f27:	55                   	push   %rbp
  801f28:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f2b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f32:	00 00 00 
  801f35:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f38:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801f3a:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801f3d:	be 00 00 00 00       	mov    $0x0,%esi
  801f42:	bf 02 00 00 00       	mov    $0x2,%edi
  801f47:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	call   *%rax
}
  801f53:	5d                   	pop    %rbp
  801f54:	c3                   	ret

0000000000801f55 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f55:	f3 0f 1e fa          	endbr64
  801f59:	55                   	push   %rbp
  801f5a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f5d:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f60:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f67:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f69:	be 00 00 00 00       	mov    $0x0,%esi
  801f6e:	bf 06 00 00 00       	mov    $0x6,%edi
  801f73:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  801f7a:	00 00 00 
  801f7d:	ff d0                	call   *%rax
}
  801f7f:	5d                   	pop    %rbp
  801f80:	c3                   	ret

0000000000801f81 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f81:	f3 0f 1e fa          	endbr64
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	41 54                	push   %r12
  801f8b:	53                   	push   %rbx
  801f8c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f8f:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f92:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f99:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f9b:	be 00 00 00 00       	mov    $0x0,%esi
  801fa0:	bf 05 00 00 00       	mov    $0x5,%edi
  801fa5:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	call   *%rax
    if (res < 0) return res;
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	78 3d                	js     801ff2 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fb5:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  801fbc:	00 00 00 
  801fbf:	4c 89 e6             	mov    %r12,%rsi
  801fc2:	48 89 df             	mov    %rbx,%rdi
  801fc5:	48 b8 6e 0d 80 00 00 	movabs $0x800d6e,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801fd1:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801fd8:	00 
  801fd9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fdf:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801fe6:	00 
  801fe7:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff2:	5b                   	pop    %rbx
  801ff3:	41 5c                	pop    %r12
  801ff5:	5d                   	pop    %rbp
  801ff6:	c3                   	ret

0000000000801ff7 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ff7:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801ffb:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802002:	77 41                	ja     802045 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802004:	55                   	push   %rbp
  802005:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802008:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80200f:	00 00 00 
  802012:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802015:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802017:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80201b:	48 8d 78 10          	lea    0x10(%rax),%rdi
  80201f:	48 b8 89 0f 80 00 00 	movabs $0x800f89,%rax
  802026:	00 00 00 
  802029:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80202b:	be 00 00 00 00       	mov    $0x0,%esi
  802030:	bf 04 00 00 00       	mov    $0x4,%edi
  802035:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	call   *%rax
  802041:	48 98                	cltq
}
  802043:	5d                   	pop    %rbp
  802044:	c3                   	ret
        return -E_INVAL;
  802045:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80204c:	c3                   	ret

000000000080204d <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80204d:	f3 0f 1e fa          	endbr64
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	41 55                	push   %r13
  802057:	41 54                	push   %r12
  802059:	53                   	push   %rbx
  80205a:	48 83 ec 08          	sub    $0x8,%rsp
  80205e:	49 89 f4             	mov    %rsi,%r12
  802061:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802064:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80206b:	00 00 00 
  80206e:	8b 57 0c             	mov    0xc(%rdi),%edx
  802071:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802073:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802077:	be 00 00 00 00       	mov    $0x0,%esi
  80207c:	bf 03 00 00 00       	mov    $0x3,%edi
  802081:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  802088:	00 00 00 
  80208b:	ff d0                	call   *%rax
  80208d:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802090:	4d 85 ed             	test   %r13,%r13
  802093:	78 2a                	js     8020bf <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802095:	4c 89 ea             	mov    %r13,%rdx
  802098:	4c 39 eb             	cmp    %r13,%rbx
  80209b:	72 30                	jb     8020cd <devfile_read+0x80>
  80209d:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8020a4:	7f 27                	jg     8020cd <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8020a6:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8020ad:	00 00 00 
  8020b0:	4c 89 e7             	mov    %r12,%rdi
  8020b3:	48 b8 89 0f 80 00 00 	movabs $0x800f89,%rax
  8020ba:	00 00 00 
  8020bd:	ff d0                	call   *%rax
}
  8020bf:	4c 89 e8             	mov    %r13,%rax
  8020c2:	48 83 c4 08          	add    $0x8,%rsp
  8020c6:	5b                   	pop    %rbx
  8020c7:	41 5c                	pop    %r12
  8020c9:	41 5d                	pop    %r13
  8020cb:	5d                   	pop    %rbp
  8020cc:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8020cd:	48 b9 ab 42 80 00 00 	movabs $0x8042ab,%rcx
  8020d4:	00 00 00 
  8020d7:	48 ba c8 42 80 00 00 	movabs $0x8042c8,%rdx
  8020de:	00 00 00 
  8020e1:	be 7b 00 00 00       	mov    $0x7b,%esi
  8020e6:	48 bf dd 42 80 00 00 	movabs $0x8042dd,%rdi
  8020ed:	00 00 00 
  8020f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f5:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  8020fc:	00 00 00 
  8020ff:	41 ff d0             	call   *%r8

0000000000802102 <open>:
open(const char *path, int mode) {
  802102:	f3 0f 1e fa          	endbr64
  802106:	55                   	push   %rbp
  802107:	48 89 e5             	mov    %rsp,%rbp
  80210a:	41 55                	push   %r13
  80210c:	41 54                	push   %r12
  80210e:	53                   	push   %rbx
  80210f:	48 83 ec 18          	sub    $0x18,%rsp
  802113:	49 89 fc             	mov    %rdi,%r12
  802116:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802119:	48 b8 29 0d 80 00 00 	movabs $0x800d29,%rax
  802120:	00 00 00 
  802123:	ff d0                	call   *%rax
  802125:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80212b:	0f 87 8a 00 00 00    	ja     8021bb <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802131:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802135:	48 b8 6d 17 80 00 00 	movabs $0x80176d,%rax
  80213c:	00 00 00 
  80213f:	ff d0                	call   *%rax
  802141:	89 c3                	mov    %eax,%ebx
  802143:	85 c0                	test   %eax,%eax
  802145:	78 50                	js     802197 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802147:	4c 89 e6             	mov    %r12,%rsi
  80214a:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802151:	00 00 00 
  802154:	48 89 df             	mov    %rbx,%rdi
  802157:	48 b8 6e 0d 80 00 00 	movabs $0x800d6e,%rax
  80215e:	00 00 00 
  802161:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802163:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80216a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80216e:	bf 01 00 00 00       	mov    $0x1,%edi
  802173:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	call   *%rax
  80217f:	89 c3                	mov    %eax,%ebx
  802181:	85 c0                	test   %eax,%eax
  802183:	78 1f                	js     8021a4 <open+0xa2>
    return fd2num(fd);
  802185:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802189:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  802190:	00 00 00 
  802193:	ff d0                	call   *%rax
  802195:	89 c3                	mov    %eax,%ebx
}
  802197:	89 d8                	mov    %ebx,%eax
  802199:	48 83 c4 18          	add    $0x18,%rsp
  80219d:	5b                   	pop    %rbx
  80219e:	41 5c                	pop    %r12
  8021a0:	41 5d                	pop    %r13
  8021a2:	5d                   	pop    %rbp
  8021a3:	c3                   	ret
        fd_close(fd, 0);
  8021a4:	be 00 00 00 00       	mov    $0x0,%esi
  8021a9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021ad:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	call   *%rax
        return res;
  8021b9:	eb dc                	jmp    802197 <open+0x95>
        return -E_BAD_PATH;
  8021bb:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8021c0:	eb d5                	jmp    802197 <open+0x95>

00000000008021c2 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8021c2:	f3 0f 1e fa          	endbr64
  8021c6:	55                   	push   %rbp
  8021c7:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8021ca:	be 00 00 00 00       	mov    $0x0,%esi
  8021cf:	bf 08 00 00 00       	mov    $0x8,%edi
  8021d4:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	call   *%rax
}
  8021e0:	5d                   	pop    %rbp
  8021e1:	c3                   	ret

00000000008021e2 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8021e2:	f3 0f 1e fa          	endbr64
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	41 55                	push   %r13
  8021ec:	41 54                	push   %r12
  8021ee:	53                   	push   %rbx
  8021ef:	48 83 ec 08          	sub    $0x8,%rsp
  8021f3:	48 89 fb             	mov    %rdi,%rbx
  8021f6:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8021f9:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8021fc:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  802203:	00 00 00 
  802206:	ff d0                	call   *%rax
  802208:	41 89 c1             	mov    %eax,%r9d
  80220b:	4d 89 e0             	mov    %r12,%r8
  80220e:	49 29 d8             	sub    %rbx,%r8
  802211:	48 89 d9             	mov    %rbx,%rcx
  802214:	44 89 ea             	mov    %r13d,%edx
  802217:	48 89 de             	mov    %rbx,%rsi
  80221a:	bf 00 00 00 00       	mov    $0x0,%edi
  80221f:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  802226:	00 00 00 
  802229:	ff d0                	call   *%rax
}
  80222b:	48 83 c4 08          	add    $0x8,%rsp
  80222f:	5b                   	pop    %rbx
  802230:	41 5c                	pop    %r12
  802232:	41 5d                	pop    %r13
  802234:	5d                   	pop    %rbp
  802235:	c3                   	ret

0000000000802236 <spawn>:
spawn(const char *prog, const char **argv) {
  802236:	f3 0f 1e fa          	endbr64
  80223a:	55                   	push   %rbp
  80223b:	48 89 e5             	mov    %rsp,%rbp
  80223e:	41 57                	push   %r15
  802240:	41 56                	push   %r14
  802242:	41 55                	push   %r13
  802244:	41 54                	push   %r12
  802246:	53                   	push   %rbx
  802247:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  80224e:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  802251:	be 00 00 00 00       	mov    $0x0,%esi
  802256:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  80225d:	00 00 00 
  802260:	ff d0                	call   *%rax
  802262:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  802268:	85 c0                	test   %eax,%eax
  80226a:	0f 88 30 06 00 00    	js     8028a0 <spawn+0x66a>
  802270:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  802272:	ba 00 02 00 00       	mov    $0x200,%edx
  802277:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80227e:	48 b8 8e 1b 80 00 00 	movabs $0x801b8e,%rax
  802285:	00 00 00 
  802288:	ff d0                	call   *%rax
  80228a:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  80228c:	3d 00 02 00 00       	cmp    $0x200,%eax
  802291:	0f 85 7d 02 00 00    	jne    802514 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  802297:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80229e:	ff ff 00 
  8022a1:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  8022a8:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  8022af:	01 01 00 
  8022b2:	48 39 d0             	cmp    %rdx,%rax
  8022b5:	0f 85 95 02 00 00    	jne    802550 <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  8022bb:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8022c2:	00 3e 00 
  8022c5:	0f 85 85 02 00 00    	jne    802550 <spawn+0x31a>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8022cb:	b8 09 00 00 00       	mov    $0x9,%eax
  8022d0:	cd 30                	int    $0x30
  8022d2:	41 89 c6             	mov    %eax,%r14d
  8022d5:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	0f 88 a9 05 00 00    	js     802888 <spawn+0x652>
    envid_t child = res;
  8022df:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8022e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022ea:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8022ee:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8022f2:	48 c1 e0 04          	shl    $0x4,%rax
  8022f6:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8022fd:	00 00 00 
  802300:	48 01 c6             	add    %rax,%rsi
  802303:	48 8b 06             	mov    (%rsi),%rax
  802306:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  80230d:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  802314:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  80231b:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  802322:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  802329:	48 29 ce             	sub    %rcx,%rsi
  80232c:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  802332:	c1 e9 03             	shr    $0x3,%ecx
  802335:	89 c9                	mov    %ecx,%ecx
  802337:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  80233a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802341:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  802348:	49 8b 3c 24          	mov    (%r12),%rdi
  80234c:	48 85 ff             	test   %rdi,%rdi
  80234f:	0f 84 7f 05 00 00    	je     8028d4 <spawn+0x69e>
  802355:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  80235b:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  802361:	48 bb 29 0d 80 00 00 	movabs $0x800d29,%rbx
  802368:	00 00 00 
  80236b:	ff d3                	call   *%rbx
  80236d:	4c 01 f8             	add    %r15,%rax
  802370:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  802374:	4c 89 ea             	mov    %r13,%rdx
  802377:	49 83 c5 01          	add    $0x1,%r13
  80237b:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  802380:	48 85 ff             	test   %rdi,%rdi
  802383:	75 e6                	jne    80236b <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802385:	49 89 d5             	mov    %rdx,%r13
  802388:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80238f:	48 f7 d0             	not    %rax
  802392:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802399:	49 89 df             	mov    %rbx,%r15
  80239c:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  8023a0:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  8023a7:	89 d0                	mov    %edx,%eax
  8023a9:	83 c0 01             	add    $0x1,%eax
  8023ac:	48 98                	cltq
  8023ae:	48 c1 e0 03          	shl    $0x3,%rax
  8023b2:	49 29 c7             	sub    %rax,%r15
  8023b5:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8023bc:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8023c0:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8023c6:	0f 86 ff 04 00 00    	jbe    8028cb <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8023cc:	b9 06 00 00 00       	mov    $0x6,%ecx
  8023d1:	ba 00 00 01 00       	mov    $0x10000,%edx
  8023d6:	be 00 00 40 00       	mov    $0x400000,%esi
  8023db:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	call   *%rax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	0f 88 e1 04 00 00    	js     8028d0 <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8023ef:	4c 89 e8             	mov    %r13,%rax
  8023f2:	45 85 ed             	test   %r13d,%r13d
  8023f5:	7e 54                	jle    80244b <spawn+0x215>
  8023f7:	4d 89 fd             	mov    %r15,%r13
  8023fa:	48 98                	cltq
  8023fc:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  802400:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  802407:	00 00 00 
  80240a:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  802411:	ff 
  802412:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  802416:	49 8b 34 24          	mov    (%r12),%rsi
  80241a:	48 89 df             	mov    %rbx,%rdi
  80241d:	48 b8 6e 0d 80 00 00 	movabs $0x800d6e,%rax
  802424:	00 00 00 
  802427:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  802429:	49 8b 3c 24          	mov    (%r12),%rdi
  80242d:	48 b8 29 0d 80 00 00 	movabs $0x800d29,%rax
  802434:	00 00 00 
  802437:	ff d0                	call   *%rax
  802439:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  80243e:	49 83 c5 08          	add    $0x8,%r13
  802442:	49 83 c4 08          	add    $0x8,%r12
  802446:	4d 39 fd             	cmp    %r15,%r13
  802449:	75 b5                	jne    802400 <spawn+0x1ca>
    argv_store[argc] = 0;
  80244b:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  802452:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802459:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80245a:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  802461:	0f 85 30 01 00 00    	jne    802597 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802467:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  80246e:	00 00 00 
  802471:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  802478:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  80247f:	ff 
  802480:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  802484:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  80248b:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  80248f:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802496:	00 00 00 
  802499:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  8024a0:	ff 
  8024a1:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  8024a8:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  8024ae:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  8024b4:	44 89 f2             	mov    %r14d,%edx
  8024b7:	be 00 00 40 00       	mov    $0x400000,%esi
  8024bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c1:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8024cd:	48 bb b3 14 80 00 00 	movabs $0x8014b3,%rbx
  8024d4:	00 00 00 
  8024d7:	ba 00 00 01 00       	mov    $0x10000,%edx
  8024dc:	be 00 00 40 00       	mov    $0x400000,%esi
  8024e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e6:	ff d3                	call   *%rbx
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	78 eb                	js     8024d7 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8024ec:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8024f3:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8024fa:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8024fb:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  802502:	00 
  802503:	0f 84 68 02 00 00    	je     802771 <spawn+0x53b>
  802509:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  80250f:	e9 c5 01 00 00       	jmp    8026d9 <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  802514:	48 bf 48 44 80 00 00 	movabs $0x804448,%rdi
  80251b:	00 00 00 
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	48 ba 25 04 80 00 00 	movabs $0x800425,%rdx
  80252a:	00 00 00 
  80252d:	ff d2                	call   *%rdx
        close(fd);
  80252f:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802535:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802541:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802548:	ff ff ff 
  80254b:	e9 50 03 00 00       	jmp    8028a0 <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802550:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802555:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  80255b:	48 bf e8 42 80 00 00 	movabs $0x8042e8,%rdi
  802562:	00 00 00 
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
  80256a:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  802571:	00 00 00 
  802574:	ff d1                	call   *%rcx
        close(fd);
  802576:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80257c:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  802583:	00 00 00 
  802586:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802588:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  80258f:	ff ff ff 
  802592:	e9 09 03 00 00       	jmp    8028a0 <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802597:	48 b9 78 44 80 00 00 	movabs $0x804478,%rcx
  80259e:	00 00 00 
  8025a1:	48 ba c8 42 80 00 00 	movabs $0x8042c8,%rdx
  8025a8:	00 00 00 
  8025ab:	be f0 00 00 00       	mov    $0xf0,%esi
  8025b0:	48 bf 02 43 80 00 00 	movabs $0x804302,%rdi
  8025b7:	00 00 00 
  8025ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bf:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  8025c6:	00 00 00 
  8025c9:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  8025cc:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  8025d2:	83 c9 02             	or     $0x2,%ecx
  8025d5:	48 89 da             	mov    %rbx,%rdx
  8025d8:	be 00 00 40 00       	mov    $0x400000,%esi
  8025dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e2:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8025e9:	00 00 00 
  8025ec:	ff d0                	call   *%rax
        if (res < 0) {
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	0f 88 7e 02 00 00    	js     802874 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8025f6:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8025fc:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802602:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  802609:	00 00 00 
  80260c:	ff d0                	call   *%rax
        if (res < 0) {
  80260e:	85 c0                	test   %eax,%eax
  802610:	0f 88 a2 02 00 00    	js     8028b8 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  802616:	48 89 da             	mov    %rbx,%rdx
  802619:	be 00 00 40 00       	mov    $0x400000,%esi
  80261e:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802624:	48 b8 8e 1b 80 00 00 	movabs $0x801b8e,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	call   *%rax
        if (res < 0) {
  802630:	85 c0                	test   %eax,%eax
  802632:	0f 88 84 02 00 00    	js     8028bc <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  802638:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  80263f:	49 89 d8             	mov    %rbx,%r8
  802642:	4c 89 e1             	mov    %r12,%rcx
  802645:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  80264b:	be 00 00 40 00       	mov    $0x400000,%esi
  802650:	bf 00 00 00 00       	mov    $0x0,%edi
  802655:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	call   *%rax
        if (res < 0) {
  802661:	85 c0                	test   %eax,%eax
  802663:	0f 88 57 02 00 00    	js     8028c0 <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  802669:	48 89 da             	mov    %rbx,%rdx
  80266c:	be 00 00 40 00       	mov    $0x400000,%esi
  802671:	bf 00 00 00 00       	mov    $0x0,%edi
  802676:	48 b8 b3 14 80 00 00 	movabs $0x8014b3,%rax
  80267d:	00 00 00 
  802680:	ff d0                	call   *%rax
        if (res < 0) {
  802682:	85 c0                	test   %eax,%eax
  802684:	0f 89 ca 00 00 00    	jns    802754 <spawn+0x51e>
  80268a:	89 c3                	mov    %eax,%ebx
  80268c:	e9 e5 01 00 00       	jmp    802876 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  802691:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802697:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  80269d:	4c 89 ea             	mov    %r13,%rdx
  8026a0:	48 29 da             	sub    %rbx,%rdx
  8026a3:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  8026a7:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  8026ad:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	0f 88 a1 00 00 00    	js     802762 <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8026c1:	49 83 c7 01          	add    $0x1,%r15
  8026c5:	49 83 c6 38          	add    $0x38,%r14
  8026c9:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8026d0:	49 39 c7             	cmp    %rax,%r15
  8026d3:	0f 83 98 00 00 00    	jae    802771 <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8026d9:	41 83 3e 01          	cmpl   $0x1,(%r14)
  8026dd:	75 e2                	jne    8026c1 <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8026df:	41 8b 46 04          	mov    0x4(%r14),%eax
  8026e3:	89 c2                	mov    %eax,%edx
  8026e5:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8026e8:	89 d1                	mov    %edx,%ecx
  8026ea:	83 c9 04             	or     $0x4,%ecx
  8026ed:	a8 04                	test   $0x4,%al
  8026ef:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8026f2:	83 e0 01             	and    $0x1,%eax
  8026f5:	09 d0                	or     %edx,%eax
  8026f7:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8026fd:	49 8b 46 08          	mov    0x8(%r14),%rax
  802701:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  802707:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  80270b:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  80270f:	4d 8b 66 10          	mov    0x10(%r14),%r12
  802713:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  802719:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  80271f:	44 89 e2             	mov    %r12d,%edx
  802722:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802728:	74 14                	je     80273e <spawn+0x508>
        va -= res;
  80272a:	48 63 ca             	movslq %edx,%rcx
  80272d:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  802730:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  802733:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  802736:	29 d0                	sub    %edx,%eax
  802738:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  80273e:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802745:	0f 87 79 01 00 00    	ja     8028c4 <spawn+0x68e>
    if (filesz != 0) {
  80274b:	48 85 db             	test   %rbx,%rbx
  80274e:	0f 85 78 fe ff ff    	jne    8025cc <spawn+0x396>
    if (memsz > filesz) {
  802754:	4c 39 eb             	cmp    %r13,%rbx
  802757:	0f 83 64 ff ff ff    	jae    8026c1 <spawn+0x48b>
  80275d:	e9 2f ff ff ff       	jmp    802691 <spawn+0x45b>
        if (res < 0) {
  802762:	ba 00 00 00 00       	mov    $0x0,%edx
  802767:	0f 4e d0             	cmovle %eax,%edx
  80276a:	89 d3                	mov    %edx,%ebx
  80276c:	e9 05 01 00 00       	jmp    802876 <spawn+0x640>
    close(fd);
  802771:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802777:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80277e:	00 00 00 
  802781:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802783:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  80278a:	48 bf e2 21 80 00 00 	movabs $0x8021e2,%rdi
  802791:	00 00 00 
  802794:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  80279b:	00 00 00 
  80279e:	ff d0                	call   *%rax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	78 49                	js     8027ed <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  8027a4:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  8027ab:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8027b1:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	call   *%rax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	78 59                	js     80281a <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8027c1:	be 02 00 00 00       	mov    $0x2,%esi
  8027c6:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8027cc:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	call   *%rax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	78 6b                	js     802847 <spawn+0x611>
    return child;
  8027dc:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8027e2:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8027e8:	e9 b3 00 00 00       	jmp    8028a0 <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8027ed:	89 c1                	mov    %eax,%ecx
  8027ef:	48 ba 0e 43 80 00 00 	movabs $0x80430e,%rdx
  8027f6:	00 00 00 
  8027f9:	be 84 00 00 00       	mov    $0x84,%esi
  8027fe:	48 bf 02 43 80 00 00 	movabs $0x804302,%rdi
  802805:	00 00 00 
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  802814:	00 00 00 
  802817:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  80281a:	89 c1                	mov    %eax,%ecx
  80281c:	48 ba 25 43 80 00 00 	movabs $0x804325,%rdx
  802823:	00 00 00 
  802826:	be 87 00 00 00       	mov    $0x87,%esi
  80282b:	48 bf 02 43 80 00 00 	movabs $0x804302,%rdi
  802832:	00 00 00 
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
  80283a:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  802841:	00 00 00 
  802844:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802847:	89 c1                	mov    %eax,%ecx
  802849:	48 ba 3f 43 80 00 00 	movabs $0x80433f,%rdx
  802850:	00 00 00 
  802853:	be 8a 00 00 00       	mov    $0x8a,%esi
  802858:	48 bf 02 43 80 00 00 	movabs $0x804302,%rdi
  80285f:	00 00 00 
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  80286e:	00 00 00 
  802871:	41 ff d0             	call   *%r8
  802874:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802876:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80287c:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  802883:	00 00 00 
  802886:	ff d0                	call   *%rax
    close(fd);
  802888:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80288e:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  802895:	00 00 00 
  802898:	ff d0                	call   *%rax
    return res;
  80289a:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  8028a0:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  8028a6:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  8028ad:	5b                   	pop    %rbx
  8028ae:	41 5c                	pop    %r12
  8028b0:	41 5d                	pop    %r13
  8028b2:	41 5e                	pop    %r14
  8028b4:	41 5f                	pop    %r15
  8028b6:	5d                   	pop    %rbp
  8028b7:	c3                   	ret
  8028b8:	89 c3                	mov    %eax,%ebx
  8028ba:	eb ba                	jmp    802876 <spawn+0x640>
  8028bc:	89 c3                	mov    %eax,%ebx
  8028be:	eb b6                	jmp    802876 <spawn+0x640>
  8028c0:	89 c3                	mov    %eax,%ebx
  8028c2:	eb b2                	jmp    802876 <spawn+0x640>
        return -E_INVAL;
  8028c4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  8028c9:	eb ab                	jmp    802876 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8028cb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  8028d0:	89 c3                	mov    %eax,%ebx
  8028d2:	eb a2                	jmp    802876 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8028d4:	b9 06 00 00 00       	mov    $0x6,%ecx
  8028d9:	ba 00 00 01 00       	mov    $0x10000,%edx
  8028de:	be 00 00 40 00       	mov    $0x400000,%esi
  8028e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e8:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	call   *%rax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	78 d8                	js     8028d0 <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  8028f8:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  8028ff:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802903:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  80290a:	f8 ff 40 00 
  80290e:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802915:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802919:	bb 00 00 41 00       	mov    $0x410000,%ebx
  80291e:	e9 28 fb ff ff       	jmp    80244b <spawn+0x215>

0000000000802923 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802923:	f3 0f 1e fa          	endbr64
  802927:	55                   	push   %rbp
  802928:	48 89 e5             	mov    %rsp,%rbp
  80292b:	48 83 ec 50          	sub    $0x50,%rsp
  80292f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802933:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802937:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80293b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  80293f:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802946:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80294a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80294e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802952:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802956:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  80295b:	eb 15                	jmp    802972 <spawnl+0x4f>
  80295d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802961:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802965:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802969:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  80296d:	74 1c                	je     80298b <spawnl+0x68>
  80296f:	83 c1 01             	add    $0x1,%ecx
  802972:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802975:	83 f8 2f             	cmp    $0x2f,%eax
  802978:	77 e3                	ja     80295d <spawnl+0x3a>
  80297a:	89 c2                	mov    %eax,%edx
  80297c:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802980:	4c 01 d2             	add    %r10,%rdx
  802983:	83 c0 08             	add    $0x8,%eax
  802986:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802989:	eb de                	jmp    802969 <spawnl+0x46>
    const char *argv[argc + 2];
  80298b:	8d 41 02             	lea    0x2(%rcx),%eax
  80298e:	48 98                	cltq
  802990:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802997:	00 
  802998:	49 89 c0             	mov    %rax,%r8
  80299b:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  80299f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8029a5:	48 89 e2             	mov    %rsp,%rdx
  8029a8:	48 29 c2             	sub    %rax,%rdx
  8029ab:	48 39 d4             	cmp    %rdx,%rsp
  8029ae:	74 12                	je     8029c2 <spawnl+0x9f>
  8029b0:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  8029b7:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  8029be:	00 00 
  8029c0:	eb e9                	jmp    8029ab <spawnl+0x88>
  8029c2:	4c 89 c0             	mov    %r8,%rax
  8029c5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8029ca:	48 29 c4             	sub    %rax,%rsp
  8029cd:	48 85 c0             	test   %rax,%rax
  8029d0:	74 06                	je     8029d8 <spawnl+0xb5>
  8029d2:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  8029d8:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  8029dd:	4c 89 c8             	mov    %r9,%rax
  8029e0:	48 c1 e8 03          	shr    $0x3,%rax
  8029e4:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  8029e8:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  8029ef:	00 
    argv[argc + 1] = NULL;
  8029f0:	8d 41 01             	lea    0x1(%rcx),%eax
  8029f3:	48 98                	cltq
  8029f5:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  8029fc:	00 
    va_start(vl, arg0);
  8029fd:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802a04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802a0c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a10:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802a14:	85 c9                	test   %ecx,%ecx
  802a16:	74 41                	je     802a59 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802a18:	49 89 c0             	mov    %rax,%r8
  802a1b:	49 8d 41 08          	lea    0x8(%r9),%rax
  802a1f:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802a22:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  802a27:	eb 1b                	jmp    802a44 <spawnl+0x121>
  802a29:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802a2d:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802a31:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802a35:	48 8b 11             	mov    (%rcx),%rdx
  802a38:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802a3b:	48 83 c0 08          	add    $0x8,%rax
  802a3f:	48 39 f0             	cmp    %rsi,%rax
  802a42:	74 15                	je     802a59 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802a44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802a47:	83 fa 2f             	cmp    $0x2f,%edx
  802a4a:	77 dd                	ja     802a29 <spawnl+0x106>
  802a4c:	89 d1                	mov    %edx,%ecx
  802a4e:	4c 01 c1             	add    %r8,%rcx
  802a51:	83 c2 08             	add    $0x8,%edx
  802a54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802a57:	eb dc                	jmp    802a35 <spawnl+0x112>
    return spawn(prog, argv);
  802a59:	4c 89 ce             	mov    %r9,%rsi
  802a5c:	48 b8 36 22 80 00 00 	movabs $0x802236,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	call   *%rax
}
  802a68:	c9                   	leave
  802a69:	c3                   	ret

0000000000802a6a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802a6a:	f3 0f 1e fa          	endbr64
  802a6e:	55                   	push   %rbp
  802a6f:	48 89 e5             	mov    %rsp,%rbp
  802a72:	41 54                	push   %r12
  802a74:	53                   	push   %rbx
  802a75:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802a78:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	call   *%rax
  802a84:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802a87:	48 be 56 43 80 00 00 	movabs $0x804356,%rsi
  802a8e:	00 00 00 
  802a91:	48 89 df             	mov    %rbx,%rdi
  802a94:	48 b8 6e 0d 80 00 00 	movabs $0x800d6e,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802aa0:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802aa5:	41 2b 04 24          	sub    (%r12),%eax
  802aa9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802aaf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802ab6:	00 00 00 
    stat->st_dev = &devpipe;
  802ab9:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802ac0:	00 00 00 
  802ac3:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
  802acf:	5b                   	pop    %rbx
  802ad0:	41 5c                	pop    %r12
  802ad2:	5d                   	pop    %rbp
  802ad3:	c3                   	ret

0000000000802ad4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802ad4:	f3 0f 1e fa          	endbr64
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	41 54                	push   %r12
  802ade:	53                   	push   %rbx
  802adf:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802ae2:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ae7:	48 89 fe             	mov    %rdi,%rsi
  802aea:	bf 00 00 00 00       	mov    $0x0,%edi
  802aef:	49 bc b3 14 80 00 00 	movabs $0x8014b3,%r12
  802af6:	00 00 00 
  802af9:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802afc:	48 89 df             	mov    %rbx,%rdi
  802aff:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802b06:	00 00 00 
  802b09:	ff d0                	call   *%rax
  802b0b:	48 89 c6             	mov    %rax,%rsi
  802b0e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b13:	bf 00 00 00 00       	mov    $0x0,%edi
  802b18:	41 ff d4             	call   *%r12
}
  802b1b:	5b                   	pop    %rbx
  802b1c:	41 5c                	pop    %r12
  802b1e:	5d                   	pop    %rbp
  802b1f:	c3                   	ret

0000000000802b20 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802b20:	f3 0f 1e fa          	endbr64
  802b24:	55                   	push   %rbp
  802b25:	48 89 e5             	mov    %rsp,%rbp
  802b28:	41 57                	push   %r15
  802b2a:	41 56                	push   %r14
  802b2c:	41 55                	push   %r13
  802b2e:	41 54                	push   %r12
  802b30:	53                   	push   %rbx
  802b31:	48 83 ec 18          	sub    $0x18,%rsp
  802b35:	49 89 fc             	mov    %rdi,%r12
  802b38:	49 89 f5             	mov    %rsi,%r13
  802b3b:	49 89 d7             	mov    %rdx,%r15
  802b3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802b42:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802b4e:	4d 85 ff             	test   %r15,%r15
  802b51:	0f 84 af 00 00 00    	je     802c06 <devpipe_write+0xe6>
  802b57:	48 89 c3             	mov    %rax,%rbx
  802b5a:	4c 89 f8             	mov    %r15,%rax
  802b5d:	4d 89 ef             	mov    %r13,%r15
  802b60:	4c 01 e8             	add    %r13,%rax
  802b63:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b67:	49 bd 43 13 80 00 00 	movabs $0x801343,%r13
  802b6e:	00 00 00 
            sys_yield();
  802b71:	49 be d8 12 80 00 00 	movabs $0x8012d8,%r14
  802b78:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802b7b:	8b 73 04             	mov    0x4(%rbx),%esi
  802b7e:	48 63 ce             	movslq %esi,%rcx
  802b81:	48 63 03             	movslq (%rbx),%rax
  802b84:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802b8a:	48 39 c1             	cmp    %rax,%rcx
  802b8d:	72 2e                	jb     802bbd <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b8f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b94:	48 89 da             	mov    %rbx,%rdx
  802b97:	be 00 10 00 00       	mov    $0x1000,%esi
  802b9c:	4c 89 e7             	mov    %r12,%rdi
  802b9f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	74 66                	je     802c0c <devpipe_write+0xec>
            sys_yield();
  802ba6:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802ba9:	8b 73 04             	mov    0x4(%rbx),%esi
  802bac:	48 63 ce             	movslq %esi,%rcx
  802baf:	48 63 03             	movslq (%rbx),%rax
  802bb2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802bb8:	48 39 c1             	cmp    %rax,%rcx
  802bbb:	73 d2                	jae    802b8f <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802bbd:	41 0f b6 3f          	movzbl (%r15),%edi
  802bc1:	48 89 ca             	mov    %rcx,%rdx
  802bc4:	48 c1 ea 03          	shr    $0x3,%rdx
  802bc8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802bcf:	08 10 20 
  802bd2:	48 f7 e2             	mul    %rdx
  802bd5:	48 c1 ea 06          	shr    $0x6,%rdx
  802bd9:	48 89 d0             	mov    %rdx,%rax
  802bdc:	48 c1 e0 09          	shl    $0x9,%rax
  802be0:	48 29 d0             	sub    %rdx,%rax
  802be3:	48 c1 e0 03          	shl    $0x3,%rax
  802be7:	48 29 c1             	sub    %rax,%rcx
  802bea:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802bef:	83 c6 01             	add    $0x1,%esi
  802bf2:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802bf5:	49 83 c7 01          	add    $0x1,%r15
  802bf9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bfd:	49 39 c7             	cmp    %rax,%r15
  802c00:	0f 85 75 ff ff ff    	jne    802b7b <devpipe_write+0x5b>
    return n;
  802c06:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802c0a:	eb 05                	jmp    802c11 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c11:	48 83 c4 18          	add    $0x18,%rsp
  802c15:	5b                   	pop    %rbx
  802c16:	41 5c                	pop    %r12
  802c18:	41 5d                	pop    %r13
  802c1a:	41 5e                	pop    %r14
  802c1c:	41 5f                	pop    %r15
  802c1e:	5d                   	pop    %rbp
  802c1f:	c3                   	ret

0000000000802c20 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802c20:	f3 0f 1e fa          	endbr64
  802c24:	55                   	push   %rbp
  802c25:	48 89 e5             	mov    %rsp,%rbp
  802c28:	41 57                	push   %r15
  802c2a:	41 56                	push   %r14
  802c2c:	41 55                	push   %r13
  802c2e:	41 54                	push   %r12
  802c30:	53                   	push   %rbx
  802c31:	48 83 ec 18          	sub    $0x18,%rsp
  802c35:	49 89 fc             	mov    %rdi,%r12
  802c38:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802c3c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802c40:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802c47:	00 00 00 
  802c4a:	ff d0                	call   *%rax
  802c4c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802c4f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802c55:	49 bd 43 13 80 00 00 	movabs $0x801343,%r13
  802c5c:	00 00 00 
            sys_yield();
  802c5f:	49 be d8 12 80 00 00 	movabs $0x8012d8,%r14
  802c66:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802c69:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802c6e:	74 7d                	je     802ced <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802c70:	8b 03                	mov    (%rbx),%eax
  802c72:	3b 43 04             	cmp    0x4(%rbx),%eax
  802c75:	75 26                	jne    802c9d <devpipe_read+0x7d>
            if (i > 0) return i;
  802c77:	4d 85 ff             	test   %r15,%r15
  802c7a:	75 77                	jne    802cf3 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802c7c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802c81:	48 89 da             	mov    %rbx,%rdx
  802c84:	be 00 10 00 00       	mov    $0x1000,%esi
  802c89:	4c 89 e7             	mov    %r12,%rdi
  802c8c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 72                	je     802d05 <devpipe_read+0xe5>
            sys_yield();
  802c93:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802c96:	8b 03                	mov    (%rbx),%eax
  802c98:	3b 43 04             	cmp    0x4(%rbx),%eax
  802c9b:	74 df                	je     802c7c <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c9d:	48 63 c8             	movslq %eax,%rcx
  802ca0:	48 89 ca             	mov    %rcx,%rdx
  802ca3:	48 c1 ea 03          	shr    $0x3,%rdx
  802ca7:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802cae:	08 10 20 
  802cb1:	48 89 d0             	mov    %rdx,%rax
  802cb4:	48 f7 e6             	mul    %rsi
  802cb7:	48 c1 ea 06          	shr    $0x6,%rdx
  802cbb:	48 89 d0             	mov    %rdx,%rax
  802cbe:	48 c1 e0 09          	shl    $0x9,%rax
  802cc2:	48 29 d0             	sub    %rdx,%rax
  802cc5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802ccc:	00 
  802ccd:	48 89 c8             	mov    %rcx,%rax
  802cd0:	48 29 d0             	sub    %rdx,%rax
  802cd3:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802cd8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802cdc:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802ce0:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ce3:	49 83 c7 01          	add    $0x1,%r15
  802ce7:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802ceb:	75 83                	jne    802c70 <devpipe_read+0x50>
    return n;
  802ced:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802cf1:	eb 03                	jmp    802cf6 <devpipe_read+0xd6>
            if (i > 0) return i;
  802cf3:	4c 89 f8             	mov    %r15,%rax
}
  802cf6:	48 83 c4 18          	add    $0x18,%rsp
  802cfa:	5b                   	pop    %rbx
  802cfb:	41 5c                	pop    %r12
  802cfd:	41 5d                	pop    %r13
  802cff:	41 5e                	pop    %r14
  802d01:	41 5f                	pop    %r15
  802d03:	5d                   	pop    %rbp
  802d04:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0a:	eb ea                	jmp    802cf6 <devpipe_read+0xd6>

0000000000802d0c <pipe>:
pipe(int pfd[2]) {
  802d0c:	f3 0f 1e fa          	endbr64
  802d10:	55                   	push   %rbp
  802d11:	48 89 e5             	mov    %rsp,%rbp
  802d14:	41 55                	push   %r13
  802d16:	41 54                	push   %r12
  802d18:	53                   	push   %rbx
  802d19:	48 83 ec 18          	sub    $0x18,%rsp
  802d1d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802d20:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802d24:	48 b8 6d 17 80 00 00 	movabs $0x80176d,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	call   *%rax
  802d30:	89 c3                	mov    %eax,%ebx
  802d32:	85 c0                	test   %eax,%eax
  802d34:	0f 88 a0 01 00 00    	js     802eda <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802d3a:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d3f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d44:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802d48:	bf 00 00 00 00       	mov    $0x0,%edi
  802d4d:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	call   *%rax
  802d59:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	0f 88 77 01 00 00    	js     802eda <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802d63:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802d67:	48 b8 6d 17 80 00 00 	movabs $0x80176d,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	call   *%rax
  802d73:	89 c3                	mov    %eax,%ebx
  802d75:	85 c0                	test   %eax,%eax
  802d77:	0f 88 43 01 00 00    	js     802ec0 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802d7d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d82:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d87:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d8b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d90:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	call   *%rax
  802d9c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	0f 88 1a 01 00 00    	js     802ec0 <pipe+0x1b4>
    va = fd2data(fd0);
  802da6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802daa:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	call   *%rax
  802db6:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802db9:	b9 46 00 00 00       	mov    $0x46,%ecx
  802dbe:	ba 00 10 00 00       	mov    $0x1000,%edx
  802dc3:	48 89 c6             	mov    %rax,%rsi
  802dc6:	bf 00 00 00 00       	mov    $0x0,%edi
  802dcb:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  802dd2:	00 00 00 
  802dd5:	ff d0                	call   *%rax
  802dd7:	89 c3                	mov    %eax,%ebx
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	0f 88 c5 00 00 00    	js     802ea6 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802de1:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802de5:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802dec:	00 00 00 
  802def:	ff d0                	call   *%rax
  802df1:	48 89 c1             	mov    %rax,%rcx
  802df4:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802dfa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802e00:	ba 00 00 00 00       	mov    $0x0,%edx
  802e05:	4c 89 ee             	mov    %r13,%rsi
  802e08:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0d:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	call   *%rax
  802e19:	89 c3                	mov    %eax,%ebx
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	78 6e                	js     802e8d <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802e1f:	be 00 10 00 00       	mov    $0x1000,%esi
  802e24:	4c 89 ef             	mov    %r13,%rdi
  802e27:	48 b8 0d 13 80 00 00 	movabs $0x80130d,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	call   *%rax
  802e33:	83 f8 02             	cmp    $0x2,%eax
  802e36:	0f 85 ab 00 00 00    	jne    802ee7 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802e3c:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802e43:	00 00 
  802e45:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e49:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802e4b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e4f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802e56:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802e5a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802e5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e60:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802e67:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802e6b:	48 bb 37 17 80 00 00 	movabs $0x801737,%rbx
  802e72:	00 00 00 
  802e75:	ff d3                	call   *%rbx
  802e77:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802e7b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802e7f:	ff d3                	call   *%rbx
  802e81:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e8b:	eb 4d                	jmp    802eda <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802e8d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e92:	4c 89 ee             	mov    %r13,%rsi
  802e95:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9a:	48 b8 b3 14 80 00 00 	movabs $0x8014b3,%rax
  802ea1:	00 00 00 
  802ea4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802ea6:	ba 00 10 00 00       	mov    $0x1000,%edx
  802eab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802eaf:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb4:	48 b8 b3 14 80 00 00 	movabs $0x8014b3,%rax
  802ebb:	00 00 00 
  802ebe:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802ec0:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ec5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802ec9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ece:	48 b8 b3 14 80 00 00 	movabs $0x8014b3,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	call   *%rax
}
  802eda:	89 d8                	mov    %ebx,%eax
  802edc:	48 83 c4 18          	add    $0x18,%rsp
  802ee0:	5b                   	pop    %rbx
  802ee1:	41 5c                	pop    %r12
  802ee3:	41 5d                	pop    %r13
  802ee5:	5d                   	pop    %rbp
  802ee6:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802ee7:	48 b9 a8 44 80 00 00 	movabs $0x8044a8,%rcx
  802eee:	00 00 00 
  802ef1:	48 ba c8 42 80 00 00 	movabs $0x8042c8,%rdx
  802ef8:	00 00 00 
  802efb:	be 2e 00 00 00       	mov    $0x2e,%esi
  802f00:	48 bf 5d 43 80 00 00 	movabs $0x80435d,%rdi
  802f07:	00 00 00 
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  802f16:	00 00 00 
  802f19:	41 ff d0             	call   *%r8

0000000000802f1c <pipeisclosed>:
pipeisclosed(int fdnum) {
  802f1c:	f3 0f 1e fa          	endbr64
  802f20:	55                   	push   %rbp
  802f21:	48 89 e5             	mov    %rsp,%rbp
  802f24:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802f28:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802f2c:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	call   *%rax
    if (res < 0) return res;
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	78 35                	js     802f71 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802f3c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f40:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802f47:	00 00 00 
  802f4a:	ff d0                	call   *%rax
  802f4c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802f4f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802f54:	be 00 10 00 00       	mov    $0x1000,%esi
  802f59:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f5d:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	call   *%rax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	0f 94 c0             	sete   %al
  802f6e:	0f b6 c0             	movzbl %al,%eax
}
  802f71:	c9                   	leave
  802f72:	c3                   	ret

0000000000802f73 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802f73:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802f77:	48 89 f8             	mov    %rdi,%rax
  802f7a:	48 c1 e8 27          	shr    $0x27,%rax
  802f7e:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802f85:	7f 00 00 
  802f88:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802f8c:	f6 c2 01             	test   $0x1,%dl
  802f8f:	74 6d                	je     802ffe <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802f91:	48 89 f8             	mov    %rdi,%rax
  802f94:	48 c1 e8 1e          	shr    $0x1e,%rax
  802f98:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802f9f:	7f 00 00 
  802fa2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802fa6:	f6 c2 01             	test   $0x1,%dl
  802fa9:	74 62                	je     80300d <get_uvpt_entry+0x9a>
  802fab:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802fb2:	7f 00 00 
  802fb5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802fb9:	f6 c2 80             	test   $0x80,%dl
  802fbc:	75 4f                	jne    80300d <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802fbe:	48 89 f8             	mov    %rdi,%rax
  802fc1:	48 c1 e8 15          	shr    $0x15,%rax
  802fc5:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802fcc:	7f 00 00 
  802fcf:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802fd3:	f6 c2 01             	test   $0x1,%dl
  802fd6:	74 44                	je     80301c <get_uvpt_entry+0xa9>
  802fd8:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802fdf:	7f 00 00 
  802fe2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802fe6:	f6 c2 80             	test   $0x80,%dl
  802fe9:	75 31                	jne    80301c <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802feb:	48 c1 ef 0c          	shr    $0xc,%rdi
  802fef:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ff6:	7f 00 00 
  802ff9:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802ffd:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802ffe:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803005:	7f 00 00 
  803008:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80300c:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80300d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803014:	7f 00 00 
  803017:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80301b:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80301c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803023:	7f 00 00 
  803026:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80302a:	c3                   	ret

000000000080302b <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80302b:	f3 0f 1e fa          	endbr64
  80302f:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803032:	48 89 f9             	mov    %rdi,%rcx
  803035:	48 c1 e9 27          	shr    $0x27,%rcx
  803039:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  803040:	7f 00 00 
  803043:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  803047:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80304e:	f6 c1 01             	test   $0x1,%cl
  803051:	0f 84 b2 00 00 00    	je     803109 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803057:	48 89 f9             	mov    %rdi,%rcx
  80305a:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80305e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803065:	7f 00 00 
  803068:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80306c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803073:	40 f6 c6 01          	test   $0x1,%sil
  803077:	0f 84 8c 00 00 00    	je     803109 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80307d:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803084:	7f 00 00 
  803087:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80308b:	a8 80                	test   $0x80,%al
  80308d:	75 7b                	jne    80310a <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80308f:	48 89 f9             	mov    %rdi,%rcx
  803092:	48 c1 e9 15          	shr    $0x15,%rcx
  803096:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80309d:	7f 00 00 
  8030a0:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8030a4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8030ab:	40 f6 c6 01          	test   $0x1,%sil
  8030af:	74 58                	je     803109 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8030b1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8030b8:	7f 00 00 
  8030bb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8030bf:	a8 80                	test   $0x80,%al
  8030c1:	75 6c                	jne    80312f <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8030c3:	48 89 f9             	mov    %rdi,%rcx
  8030c6:	48 c1 e9 0c          	shr    $0xc,%rcx
  8030ca:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8030d1:	7f 00 00 
  8030d4:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8030d8:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8030df:	40 f6 c6 01          	test   $0x1,%sil
  8030e3:	74 24                	je     803109 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8030e5:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8030ec:	7f 00 00 
  8030ef:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8030f3:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8030fa:	ff ff 7f 
  8030fd:	48 21 c8             	and    %rcx,%rax
  803100:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  803106:	48 09 d0             	or     %rdx,%rax
}
  803109:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80310a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803111:	7f 00 00 
  803114:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803118:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80311f:	ff ff 7f 
  803122:	48 21 c8             	and    %rcx,%rax
  803125:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80312b:	48 01 d0             	add    %rdx,%rax
  80312e:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  80312f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803136:	7f 00 00 
  803139:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80313d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  803144:	ff ff 7f 
  803147:	48 21 c8             	and    %rcx,%rax
  80314a:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  803150:	48 01 d0             	add    %rdx,%rax
  803153:	c3                   	ret

0000000000803154 <get_prot>:

int
get_prot(void *va) {
  803154:	f3 0f 1e fa          	endbr64
  803158:	55                   	push   %rbp
  803159:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80315c:	48 b8 73 2f 80 00 00 	movabs $0x802f73,%rax
  803163:	00 00 00 
  803166:	ff d0                	call   *%rax
  803168:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80316b:	83 e0 01             	and    $0x1,%eax
  80316e:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803171:	89 d1                	mov    %edx,%ecx
  803173:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  803179:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80317b:	89 c1                	mov    %eax,%ecx
  80317d:	83 c9 02             	or     $0x2,%ecx
  803180:	f6 c2 02             	test   $0x2,%dl
  803183:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803186:	89 c1                	mov    %eax,%ecx
  803188:	83 c9 01             	or     $0x1,%ecx
  80318b:	48 85 d2             	test   %rdx,%rdx
  80318e:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803191:	89 c1                	mov    %eax,%ecx
  803193:	83 c9 40             	or     $0x40,%ecx
  803196:	f6 c6 04             	test   $0x4,%dh
  803199:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80319c:	5d                   	pop    %rbp
  80319d:	c3                   	ret

000000000080319e <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80319e:	f3 0f 1e fa          	endbr64
  8031a2:	55                   	push   %rbp
  8031a3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8031a6:	48 b8 73 2f 80 00 00 	movabs $0x802f73,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	call   *%rax
    return pte & PTE_D;
  8031b2:	48 c1 e8 06          	shr    $0x6,%rax
  8031b6:	83 e0 01             	and    $0x1,%eax
}
  8031b9:	5d                   	pop    %rbp
  8031ba:	c3                   	ret

00000000008031bb <is_page_present>:

bool
is_page_present(void *va) {
  8031bb:	f3 0f 1e fa          	endbr64
  8031bf:	55                   	push   %rbp
  8031c0:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8031c3:	48 b8 73 2f 80 00 00 	movabs $0x802f73,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	call   *%rax
  8031cf:	83 e0 01             	and    $0x1,%eax
}
  8031d2:	5d                   	pop    %rbp
  8031d3:	c3                   	ret

00000000008031d4 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8031d4:	f3 0f 1e fa          	endbr64
  8031d8:	55                   	push   %rbp
  8031d9:	48 89 e5             	mov    %rsp,%rbp
  8031dc:	41 57                	push   %r15
  8031de:	41 56                	push   %r14
  8031e0:	41 55                	push   %r13
  8031e2:	41 54                	push   %r12
  8031e4:	53                   	push   %rbx
  8031e5:	48 83 ec 18          	sub    $0x18,%rsp
  8031e9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8031ed:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8031f1:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8031f6:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8031fd:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803200:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  803207:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80320a:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  803211:	00 00 00 
  803214:	eb 73                	jmp    803289 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  803216:	48 89 d8             	mov    %rbx,%rax
  803219:	48 c1 e8 15          	shr    $0x15,%rax
  80321d:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  803224:	7f 00 00 
  803227:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80322b:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  803231:	f6 c2 01             	test   $0x1,%dl
  803234:	74 4b                	je     803281 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  803236:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80323a:	f6 c2 80             	test   $0x80,%dl
  80323d:	74 11                	je     803250 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80323f:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  803243:	f6 c4 04             	test   $0x4,%ah
  803246:	74 39                	je     803281 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  803248:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80324e:	eb 20                	jmp    803270 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803250:	48 89 da             	mov    %rbx,%rdx
  803253:	48 c1 ea 0c          	shr    $0xc,%rdx
  803257:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80325e:	7f 00 00 
  803261:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  803265:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80326b:	f6 c4 04             	test   $0x4,%ah
  80326e:	74 11                	je     803281 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  803270:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  803274:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803278:	48 89 df             	mov    %rbx,%rdi
  80327b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80327f:	ff d0                	call   *%rax
    next:
        va += size;
  803281:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  803284:	49 39 df             	cmp    %rbx,%r15
  803287:	72 3e                	jb     8032c7 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  803289:	49 8b 06             	mov    (%r14),%rax
  80328c:	a8 01                	test   $0x1,%al
  80328e:	74 37                	je     8032c7 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803290:	48 89 d8             	mov    %rbx,%rax
  803293:	48 c1 e8 1e          	shr    $0x1e,%rax
  803297:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80329c:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8032a2:	f6 c2 01             	test   $0x1,%dl
  8032a5:	74 da                	je     803281 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8032a7:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8032ac:	f6 c2 80             	test   $0x80,%dl
  8032af:	0f 84 61 ff ff ff    	je     803216 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8032b5:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8032ba:	f6 c4 04             	test   $0x4,%ah
  8032bd:	74 c2                	je     803281 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8032bf:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8032c5:	eb a9                	jmp    803270 <foreach_shared_region+0x9c>
    }
    return res;
}
  8032c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cc:	48 83 c4 18          	add    $0x18,%rsp
  8032d0:	5b                   	pop    %rbx
  8032d1:	41 5c                	pop    %r12
  8032d3:	41 5d                	pop    %r13
  8032d5:	41 5e                	pop    %r14
  8032d7:	41 5f                	pop    %r15
  8032d9:	5d                   	pop    %rbp
  8032da:	c3                   	ret

00000000008032db <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8032db:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8032df:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e4:	c3                   	ret

00000000008032e5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8032e5:	f3 0f 1e fa          	endbr64
  8032e9:	55                   	push   %rbp
  8032ea:	48 89 e5             	mov    %rsp,%rbp
  8032ed:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8032f0:	48 be 6d 43 80 00 00 	movabs $0x80436d,%rsi
  8032f7:	00 00 00 
  8032fa:	48 b8 6e 0d 80 00 00 	movabs $0x800d6e,%rax
  803301:	00 00 00 
  803304:	ff d0                	call   *%rax
    return 0;
}
  803306:	b8 00 00 00 00       	mov    $0x0,%eax
  80330b:	5d                   	pop    %rbp
  80330c:	c3                   	ret

000000000080330d <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80330d:	f3 0f 1e fa          	endbr64
  803311:	55                   	push   %rbp
  803312:	48 89 e5             	mov    %rsp,%rbp
  803315:	41 57                	push   %r15
  803317:	41 56                	push   %r14
  803319:	41 55                	push   %r13
  80331b:	41 54                	push   %r12
  80331d:	53                   	push   %rbx
  80331e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  803325:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80332c:	48 85 d2             	test   %rdx,%rdx
  80332f:	74 7a                	je     8033ab <devcons_write+0x9e>
  803331:	49 89 d6             	mov    %rdx,%r14
  803334:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80333a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80333f:	49 bf 89 0f 80 00 00 	movabs $0x800f89,%r15
  803346:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  803349:	4c 89 f3             	mov    %r14,%rbx
  80334c:	48 29 f3             	sub    %rsi,%rbx
  80334f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803354:	48 39 c3             	cmp    %rax,%rbx
  803357:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80335b:	4c 63 eb             	movslq %ebx,%r13
  80335e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  803365:	48 01 c6             	add    %rax,%rsi
  803368:	4c 89 ea             	mov    %r13,%rdx
  80336b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803372:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  803375:	4c 89 ee             	mov    %r13,%rsi
  803378:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80337f:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  803386:	00 00 00 
  803389:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80338b:	41 01 dc             	add    %ebx,%r12d
  80338e:	49 63 f4             	movslq %r12d,%rsi
  803391:	4c 39 f6             	cmp    %r14,%rsi
  803394:	72 b3                	jb     803349 <devcons_write+0x3c>
    return res;
  803396:	49 63 c4             	movslq %r12d,%rax
}
  803399:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8033a0:	5b                   	pop    %rbx
  8033a1:	41 5c                	pop    %r12
  8033a3:	41 5d                	pop    %r13
  8033a5:	41 5e                	pop    %r14
  8033a7:	41 5f                	pop    %r15
  8033a9:	5d                   	pop    %rbp
  8033aa:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8033ab:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8033b1:	eb e3                	jmp    803396 <devcons_write+0x89>

00000000008033b3 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8033b3:	f3 0f 1e fa          	endbr64
  8033b7:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8033ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8033bf:	48 85 c0             	test   %rax,%rax
  8033c2:	74 55                	je     803419 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8033c4:	55                   	push   %rbp
  8033c5:	48 89 e5             	mov    %rsp,%rbp
  8033c8:	41 55                	push   %r13
  8033ca:	41 54                	push   %r12
  8033cc:	53                   	push   %rbx
  8033cd:	48 83 ec 08          	sub    $0x8,%rsp
  8033d1:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8033d4:	48 bb ff 11 80 00 00 	movabs $0x8011ff,%rbx
  8033db:	00 00 00 
  8033de:	49 bc d8 12 80 00 00 	movabs $0x8012d8,%r12
  8033e5:	00 00 00 
  8033e8:	eb 03                	jmp    8033ed <devcons_read+0x3a>
  8033ea:	41 ff d4             	call   *%r12
  8033ed:	ff d3                	call   *%rbx
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	74 f7                	je     8033ea <devcons_read+0x37>
    if (c < 0) return c;
  8033f3:	48 63 d0             	movslq %eax,%rdx
  8033f6:	78 13                	js     80340b <devcons_read+0x58>
    if (c == 0x04) return 0;
  8033f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8033fd:	83 f8 04             	cmp    $0x4,%eax
  803400:	74 09                	je     80340b <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  803402:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  803406:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80340b:	48 89 d0             	mov    %rdx,%rax
  80340e:	48 83 c4 08          	add    $0x8,%rsp
  803412:	5b                   	pop    %rbx
  803413:	41 5c                	pop    %r12
  803415:	41 5d                	pop    %r13
  803417:	5d                   	pop    %rbp
  803418:	c3                   	ret
  803419:	48 89 d0             	mov    %rdx,%rax
  80341c:	c3                   	ret

000000000080341d <cputchar>:
cputchar(int ch) {
  80341d:	f3 0f 1e fa          	endbr64
  803421:	55                   	push   %rbp
  803422:	48 89 e5             	mov    %rsp,%rbp
  803425:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803429:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80342d:	be 01 00 00 00       	mov    $0x1,%esi
  803432:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  803436:	48 b8 ce 11 80 00 00 	movabs $0x8011ce,%rax
  80343d:	00 00 00 
  803440:	ff d0                	call   *%rax
}
  803442:	c9                   	leave
  803443:	c3                   	ret

0000000000803444 <getchar>:
getchar(void) {
  803444:	f3 0f 1e fa          	endbr64
  803448:	55                   	push   %rbp
  803449:	48 89 e5             	mov    %rsp,%rbp
  80344c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803450:	ba 01 00 00 00       	mov    $0x1,%edx
  803455:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  803459:	bf 00 00 00 00       	mov    $0x0,%edi
  80345e:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  803465:	00 00 00 
  803468:	ff d0                	call   *%rax
  80346a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80346c:	85 c0                	test   %eax,%eax
  80346e:	78 06                	js     803476 <getchar+0x32>
  803470:	74 08                	je     80347a <getchar+0x36>
  803472:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803476:	89 d0                	mov    %edx,%eax
  803478:	c9                   	leave
  803479:	c3                   	ret
    return res < 0 ? res : res ? c :
  80347a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80347f:	eb f5                	jmp    803476 <getchar+0x32>

0000000000803481 <iscons>:
iscons(int fdnum) {
  803481:	f3 0f 1e fa          	endbr64
  803485:	55                   	push   %rbp
  803486:	48 89 e5             	mov    %rsp,%rbp
  803489:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80348d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803491:	48 b8 d1 17 80 00 00 	movabs $0x8017d1,%rax
  803498:	00 00 00 
  80349b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80349d:	85 c0                	test   %eax,%eax
  80349f:	78 18                	js     8034b9 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8034a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034a5:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  8034ac:	00 00 00 
  8034af:	8b 00                	mov    (%rax),%eax
  8034b1:	39 02                	cmp    %eax,(%rdx)
  8034b3:	0f 94 c0             	sete   %al
  8034b6:	0f b6 c0             	movzbl %al,%eax
}
  8034b9:	c9                   	leave
  8034ba:	c3                   	ret

00000000008034bb <opencons>:
opencons(void) {
  8034bb:	f3 0f 1e fa          	endbr64
  8034bf:	55                   	push   %rbp
  8034c0:	48 89 e5             	mov    %rsp,%rbp
  8034c3:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8034c7:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8034cb:	48 b8 6d 17 80 00 00 	movabs $0x80176d,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	call   *%rax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	78 49                	js     803524 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8034db:	b9 46 00 00 00       	mov    $0x46,%ecx
  8034e0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8034e5:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8034e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ee:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8034f5:	00 00 00 
  8034f8:	ff d0                	call   *%rax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	78 26                	js     803524 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8034fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803502:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  803509:	00 00 
  80350b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80350d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803511:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803518:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80351f:	00 00 00 
  803522:	ff d0                	call   *%rax
}
  803524:	c9                   	leave
  803525:	c3                   	ret

0000000000803526 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803526:	f3 0f 1e fa          	endbr64
  80352a:	55                   	push   %rbp
  80352b:	48 89 e5             	mov    %rsp,%rbp
  80352e:	41 54                	push   %r12
  803530:	53                   	push   %rbx
  803531:	48 89 fb             	mov    %rdi,%rbx
  803534:	48 89 f7             	mov    %rsi,%rdi
  803537:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80353a:	48 85 f6             	test   %rsi,%rsi
  80353d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803544:	00 00 00 
  803547:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  80354b:	be 00 10 00 00       	mov    $0x1000,%esi
  803550:	48 b8 95 16 80 00 00 	movabs $0x801695,%rax
  803557:	00 00 00 
  80355a:	ff d0                	call   *%rax
    if (res < 0) {
  80355c:	85 c0                	test   %eax,%eax
  80355e:	78 45                	js     8035a5 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803560:	48 85 db             	test   %rbx,%rbx
  803563:	74 12                	je     803577 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803565:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80356c:	00 00 00 
  80356f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803575:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803577:	4d 85 e4             	test   %r12,%r12
  80357a:	74 14                	je     803590 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  80357c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803583:	00 00 00 
  803586:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80358c:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  803590:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803597:	00 00 00 
  80359a:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8035a0:	5b                   	pop    %rbx
  8035a1:	41 5c                	pop    %r12
  8035a3:	5d                   	pop    %rbp
  8035a4:	c3                   	ret
        if (from_env_store != NULL) {
  8035a5:	48 85 db             	test   %rbx,%rbx
  8035a8:	74 06                	je     8035b0 <ipc_recv+0x8a>
            *from_env_store = 0;
  8035aa:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8035b0:	4d 85 e4             	test   %r12,%r12
  8035b3:	74 eb                	je     8035a0 <ipc_recv+0x7a>
            *perm_store = 0;
  8035b5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8035bc:	00 
  8035bd:	eb e1                	jmp    8035a0 <ipc_recv+0x7a>

00000000008035bf <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8035bf:	f3 0f 1e fa          	endbr64
  8035c3:	55                   	push   %rbp
  8035c4:	48 89 e5             	mov    %rsp,%rbp
  8035c7:	41 57                	push   %r15
  8035c9:	41 56                	push   %r14
  8035cb:	41 55                	push   %r13
  8035cd:	41 54                	push   %r12
  8035cf:	53                   	push   %rbx
  8035d0:	48 83 ec 18          	sub    $0x18,%rsp
  8035d4:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8035d7:	48 89 d3             	mov    %rdx,%rbx
  8035da:	49 89 cc             	mov    %rcx,%r12
  8035dd:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8035e0:	48 85 d2             	test   %rdx,%rdx
  8035e3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8035ea:	00 00 00 
  8035ed:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8035f1:	89 f0                	mov    %esi,%eax
  8035f3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8035f7:	48 89 da             	mov    %rbx,%rdx
  8035fa:	48 89 c6             	mov    %rax,%rsi
  8035fd:	48 b8 65 16 80 00 00 	movabs $0x801665,%rax
  803604:	00 00 00 
  803607:	ff d0                	call   *%rax
    while (res < 0) {
  803609:	85 c0                	test   %eax,%eax
  80360b:	79 65                	jns    803672 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80360d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803610:	75 33                	jne    803645 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803612:	49 bf d8 12 80 00 00 	movabs $0x8012d8,%r15
  803619:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80361c:	49 be 65 16 80 00 00 	movabs $0x801665,%r14
  803623:	00 00 00 
        sys_yield();
  803626:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803629:	45 89 e8             	mov    %r13d,%r8d
  80362c:	4c 89 e1             	mov    %r12,%rcx
  80362f:	48 89 da             	mov    %rbx,%rdx
  803632:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803636:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803639:	41 ff d6             	call   *%r14
    while (res < 0) {
  80363c:	85 c0                	test   %eax,%eax
  80363e:	79 32                	jns    803672 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803640:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803643:	74 e1                	je     803626 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803645:	89 c1                	mov    %eax,%ecx
  803647:	48 ba 79 43 80 00 00 	movabs $0x804379,%rdx
  80364e:	00 00 00 
  803651:	be 42 00 00 00       	mov    $0x42,%esi
  803656:	48 bf 84 43 80 00 00 	movabs $0x804384,%rdi
  80365d:	00 00 00 
  803660:	b8 00 00 00 00       	mov    $0x0,%eax
  803665:	49 b8 c9 02 80 00 00 	movabs $0x8002c9,%r8
  80366c:	00 00 00 
  80366f:	41 ff d0             	call   *%r8
    }
}
  803672:	48 83 c4 18          	add    $0x18,%rsp
  803676:	5b                   	pop    %rbx
  803677:	41 5c                	pop    %r12
  803679:	41 5d                	pop    %r13
  80367b:	41 5e                	pop    %r14
  80367d:	41 5f                	pop    %r15
  80367f:	5d                   	pop    %rbp
  803680:	c3                   	ret

0000000000803681 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803681:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803685:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80368a:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803691:	00 00 00 
  803694:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803698:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80369c:	48 c1 e2 04          	shl    $0x4,%rdx
  8036a0:	48 01 ca             	add    %rcx,%rdx
  8036a3:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8036a9:	39 fa                	cmp    %edi,%edx
  8036ab:	74 12                	je     8036bf <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8036ad:	48 83 c0 01          	add    $0x1,%rax
  8036b1:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8036b7:	75 db                	jne    803694 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8036b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036be:	c3                   	ret
            return envs[i].env_id;
  8036bf:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8036c3:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8036c7:	48 c1 e2 04          	shl    $0x4,%rdx
  8036cb:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8036d2:	00 00 00 
  8036d5:	48 01 d0             	add    %rdx,%rax
  8036d8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8036de:	c3                   	ret

00000000008036df <__text_end>:
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
