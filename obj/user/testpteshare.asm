
obj/user/testpteshare:     file format elf64-x86-64


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
  80001e:	e8 5c 02 00 00       	call   80027f <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <childofspawn>:

    breakpoint();
}

void
childofspawn(void) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    strcpy(VA, msg2);
  80002d:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800034:	00 00 00 
  800037:	48 8b 30             	mov    (%rax),%rsi
  80003a:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  80003f:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  800046:	00 00 00 
  800049:	ff d0                	call   *%rax
    exit();
  80004b:	48 b8 31 03 80 00 00 	movabs $0x800331,%rax
  800052:	00 00 00 
  800055:	ff d0                	call   *%rax
}
  800057:	5d                   	pop    %rbp
  800058:	c3                   	ret

0000000000800059 <umain>:
umain(int argc, char **argv) {
  800059:	f3 0f 1e fa          	endbr64
  80005d:	55                   	push   %rbp
  80005e:	48 89 e5             	mov    %rsp,%rbp
  800061:	53                   	push   %rbx
  800062:	48 83 ec 08          	sub    $0x8,%rsp
    if (argc != 0)
  800066:	85 ff                	test   %edi,%edi
  800068:	0f 85 4a 01 00 00    	jne    8001b8 <umain+0x15f>
    if ((r = sys_alloc_region(0, VA, PAGE_SIZE, PROT_SHARE | PROT_RW)) < 0)
  80006e:	b9 46 00 00 00       	mov    $0x46,%ecx
  800073:	ba 00 10 00 00       	mov    $0x1000,%edx
  800078:	be 00 00 00 0a       	mov    $0xa000000,%esi
  80007d:	bf 00 00 00 00       	mov    $0x0,%edi
  800082:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  800089:	00 00 00 
  80008c:	ff d0                	call   *%rax
  80008e:	85 c0                	test   %eax,%eax
  800090:	0f 88 33 01 00 00    	js     8001c9 <umain+0x170>
    if ((r = fork()) < 0)
  800096:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	call   *%rax
  8000a2:	89 c3                	mov    %eax,%ebx
  8000a4:	85 c0                	test   %eax,%eax
  8000a6:	0f 88 4a 01 00 00    	js     8001f6 <umain+0x19d>
    if (r == 0) {
  8000ac:	0f 84 71 01 00 00    	je     800223 <umain+0x1ca>
    wait(r);
  8000b2:	89 df                	mov    %ebx,%edi
  8000b4:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  8000bb:	00 00 00 
  8000be:	ff d0                	call   *%rax
    cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000c0:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8000c7:	00 00 00 
  8000ca:	48 8b 30             	mov    (%rax),%rsi
  8000cd:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  8000d2:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	call   *%rax
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	48 be 06 40 80 00 00 	movabs $0x804006,%rsi
  8000e7:	00 00 00 
  8000ea:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000f1:	00 00 00 
  8000f4:	48 0f 44 f0          	cmove  %rax,%rsi
  8000f8:	48 bf 3c 40 80 00 00 	movabs $0x80403c,%rdi
  8000ff:	00 00 00 
  800102:	b8 00 00 00 00       	mov    $0x0,%eax
  800107:	48 ba b4 04 80 00 00 	movabs $0x8004b4,%rdx
  80010e:	00 00 00 
  800111:	ff d2                	call   *%rdx
    if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  800113:	b9 00 00 00 00       	mov    $0x0,%ecx
  800118:	48 ba 57 40 80 00 00 	movabs $0x804057,%rdx
  80011f:	00 00 00 
  800122:	48 be 5c 40 80 00 00 	movabs $0x80405c,%rsi
  800129:	00 00 00 
  80012c:	48 bf 5b 40 80 00 00 	movabs $0x80405b,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	49 b8 0e 2b 80 00 00 	movabs $0x802b0e,%r8
  800142:	00 00 00 
  800145:	41 ff d0             	call   *%r8
  800148:	89 c7                	mov    %eax,%edi
  80014a:	85 c0                	test   %eax,%eax
  80014c:	0f 88 00 01 00 00    	js     800252 <umain+0x1f9>
    wait(r);
  800152:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  800159:	00 00 00 
  80015c:	ff d0                	call   *%rax
    cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80015e:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800165:	00 00 00 
  800168:	48 8b 30             	mov    (%rax),%rsi
  80016b:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800170:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  800177:	00 00 00 
  80017a:	ff d0                	call   *%rax
  80017c:	85 c0                	test   %eax,%eax
  80017e:	48 be 06 40 80 00 00 	movabs $0x804006,%rsi
  800185:	00 00 00 
  800188:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80018f:	00 00 00 
  800192:	48 0f 44 f0          	cmove  %rax,%rsi
  800196:	48 bf 73 40 80 00 00 	movabs $0x804073,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 ba b4 04 80 00 00 	movabs $0x8004b4,%rdx
  8001ac:	00 00 00 
  8001af:	ff d2                	call   *%rdx

#include <inc/types.h>

static inline void __attribute__((always_inline))
breakpoint(void) {
    asm volatile("int3");
  8001b1:	cc                   	int3
}
  8001b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001b6:	c9                   	leave
  8001b7:	c3                   	ret
        childofspawn();
  8001b8:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001bf:	00 00 00 
  8001c2:	ff d0                	call   *%rax
  8001c4:	e9 a5 fe ff ff       	jmp    80006e <umain+0x15>
        panic("sys_page_alloc: %i", r);
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba 0c 40 80 00 00 	movabs $0x80400c,%rdx
  8001d2:	00 00 00 
  8001d5:	be 12 00 00 00       	mov    $0x12,%esi
  8001da:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	48 ba 33 40 80 00 00 	movabs $0x804033,%rdx
  8001ff:	00 00 00 
  800202:	be 16 00 00 00       	mov    $0x16,%esi
  800207:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  80020e:	00 00 00 
  800211:	b8 00 00 00 00       	mov    $0x0,%eax
  800216:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  80021d:	00 00 00 
  800220:	41 ff d0             	call   *%r8
        strcpy(VA, msg);
  800223:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80022a:	00 00 00 
  80022d:	48 8b 30             	mov    (%rax),%rsi
  800230:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800235:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	call   *%rax
        exit();
  800241:	48 b8 31 03 80 00 00 	movabs $0x800331,%rax
  800248:	00 00 00 
  80024b:	ff d0                	call   *%rax
  80024d:	e9 60 fe ff ff       	jmp    8000b2 <umain+0x59>
        panic("spawn: %i", r);
  800252:	89 c1                	mov    %eax,%ecx
  800254:	48 ba 69 40 80 00 00 	movabs $0x804069,%rdx
  80025b:	00 00 00 
  80025e:	be 20 00 00 00       	mov    $0x20,%esi
  800263:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  80026a:	00 00 00 
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
  800272:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  800279:	00 00 00 
  80027c:	41 ff d0             	call   *%r8

000000000080027f <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80027f:	f3 0f 1e fa          	endbr64
  800283:	55                   	push   %rbp
  800284:	48 89 e5             	mov    %rsp,%rbp
  800287:	41 56                	push   %r14
  800289:	41 55                	push   %r13
  80028b:	41 54                	push   %r12
  80028d:	53                   	push   %rbx
  80028e:	41 89 fd             	mov    %edi,%r13d
  800291:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800294:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80029b:	00 00 00 
  80029e:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8002a5:	00 00 00 
  8002a8:	48 39 c2             	cmp    %rax,%rdx
  8002ab:	73 17                	jae    8002c4 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8002ad:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8002b0:	49 89 c4             	mov    %rax,%r12
  8002b3:	48 83 c3 08          	add    $0x8,%rbx
  8002b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002bc:	ff 53 f8             	call   *-0x8(%rbx)
  8002bf:	4c 39 e3             	cmp    %r12,%rbx
  8002c2:	72 ef                	jb     8002b3 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8002c4:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  8002cb:	00 00 00 
  8002ce:	ff d0                	call   *%rax
  8002d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8002d9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8002dd:	48 c1 e0 04          	shl    $0x4,%rax
  8002e1:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8002e8:	00 00 00 
  8002eb:	48 01 d0             	add    %rdx,%rax
  8002ee:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8002f5:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8002f8:	45 85 ed             	test   %r13d,%r13d
  8002fb:	7e 0d                	jle    80030a <libmain+0x8b>
  8002fd:	49 8b 06             	mov    (%r14),%rax
  800300:	48 a3 10 50 80 00 00 	movabs %rax,0x805010
  800307:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80030a:	4c 89 f6             	mov    %r14,%rsi
  80030d:	44 89 ef             	mov    %r13d,%edi
  800310:	48 b8 59 00 80 00 00 	movabs $0x800059,%rax
  800317:	00 00 00 
  80031a:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80031c:	48 b8 31 03 80 00 00 	movabs $0x800331,%rax
  800323:	00 00 00 
  800326:	ff d0                	call   *%rax
#endif
}
  800328:	5b                   	pop    %rbx
  800329:	41 5c                	pop    %r12
  80032b:	41 5d                	pop    %r13
  80032d:	41 5e                	pop    %r14
  80032f:	5d                   	pop    %rbp
  800330:	c3                   	ret

0000000000800331 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800331:	f3 0f 1e fa          	endbr64
  800335:	55                   	push   %rbp
  800336:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800339:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  800340:	00 00 00 
  800343:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800345:	bf 00 00 00 00       	mov    $0x0,%edi
  80034a:	48 b8 c3 12 80 00 00 	movabs $0x8012c3,%rax
  800351:	00 00 00 
  800354:	ff d0                	call   *%rax
}
  800356:	5d                   	pop    %rbp
  800357:	c3                   	ret

0000000000800358 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800358:	f3 0f 1e fa          	endbr64
  80035c:	55                   	push   %rbp
  80035d:	48 89 e5             	mov    %rsp,%rbp
  800360:	41 56                	push   %r14
  800362:	41 55                	push   %r13
  800364:	41 54                	push   %r12
  800366:	53                   	push   %rbx
  800367:	48 83 ec 50          	sub    $0x50,%rsp
  80036b:	49 89 fc             	mov    %rdi,%r12
  80036e:	41 89 f5             	mov    %esi,%r13d
  800371:	48 89 d3             	mov    %rdx,%rbx
  800374:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800378:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80037c:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800380:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800387:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80038f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800393:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800397:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  80039e:	00 00 00 
  8003a1:	4c 8b 30             	mov    (%rax),%r14
  8003a4:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  8003ab:	00 00 00 
  8003ae:	ff d0                	call   *%rax
  8003b0:	89 c6                	mov    %eax,%esi
  8003b2:	45 89 e8             	mov    %r13d,%r8d
  8003b5:	4c 89 e1             	mov    %r12,%rcx
  8003b8:	4c 89 f2             	mov    %r14,%rdx
  8003bb:	48 bf f0 43 80 00 00 	movabs $0x8043f0,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	49 bc b4 04 80 00 00 	movabs $0x8004b4,%r12
  8003d1:	00 00 00 
  8003d4:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8003d7:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8003db:	48 89 df             	mov    %rbx,%rdi
  8003de:	48 b8 4c 04 80 00 00 	movabs $0x80044c,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	call   *%rax
    cprintf("\n");
  8003ea:	48 bf 9d 40 80 00 00 	movabs $0x80409d,%rdi
  8003f1:	00 00 00 
  8003f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f9:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8003fc:	cc                   	int3
  8003fd:	eb fd                	jmp    8003fc <_panic+0xa4>

00000000008003ff <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8003ff:	f3 0f 1e fa          	endbr64
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	53                   	push   %rbx
  800408:	48 83 ec 08          	sub    $0x8,%rsp
  80040c:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80040f:	8b 06                	mov    (%rsi),%eax
  800411:	8d 50 01             	lea    0x1(%rax),%edx
  800414:	89 16                	mov    %edx,(%rsi)
  800416:	48 98                	cltq
  800418:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80041d:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800423:	74 0a                	je     80042f <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800425:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800429:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80042d:	c9                   	leave
  80042e:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80042f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800433:	be ff 00 00 00       	mov    $0xff,%esi
  800438:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  80043f:	00 00 00 
  800442:	ff d0                	call   *%rax
        state->offset = 0;
  800444:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80044a:	eb d9                	jmp    800425 <putch+0x26>

000000000080044c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80044c:	f3 0f 1e fa          	endbr64
  800450:	55                   	push   %rbp
  800451:	48 89 e5             	mov    %rsp,%rbp
  800454:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80045b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80045e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800465:	b9 21 00 00 00       	mov    $0x21,%ecx
  80046a:	b8 00 00 00 00       	mov    $0x0,%eax
  80046f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800472:	48 89 f1             	mov    %rsi,%rcx
  800475:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80047c:	48 bf ff 03 80 00 00 	movabs $0x8003ff,%rdi
  800483:	00 00 00 
  800486:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  80048d:	00 00 00 
  800490:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800492:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800499:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8004a0:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  8004a7:	00 00 00 
  8004aa:	ff d0                	call   *%rax

    return state.count;
}
  8004ac:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8004b2:	c9                   	leave
  8004b3:	c3                   	ret

00000000008004b4 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8004b4:	f3 0f 1e fa          	endbr64
  8004b8:	55                   	push   %rbp
  8004b9:	48 89 e5             	mov    %rsp,%rbp
  8004bc:	48 83 ec 50          	sub    $0x50,%rsp
  8004c0:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8004c4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8004c8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004cc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004d0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8004d4:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8004db:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004e3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004e7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8004eb:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8004ef:	48 b8 4c 04 80 00 00 	movabs $0x80044c,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8004fb:	c9                   	leave
  8004fc:	c3                   	ret

00000000008004fd <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8004fd:	f3 0f 1e fa          	endbr64
  800501:	55                   	push   %rbp
  800502:	48 89 e5             	mov    %rsp,%rbp
  800505:	41 57                	push   %r15
  800507:	41 56                	push   %r14
  800509:	41 55                	push   %r13
  80050b:	41 54                	push   %r12
  80050d:	53                   	push   %rbx
  80050e:	48 83 ec 18          	sub    $0x18,%rsp
  800512:	49 89 fc             	mov    %rdi,%r12
  800515:	49 89 f5             	mov    %rsi,%r13
  800518:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80051c:	8b 45 10             	mov    0x10(%rbp),%eax
  80051f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800522:	41 89 cf             	mov    %ecx,%r15d
  800525:	4c 39 fa             	cmp    %r15,%rdx
  800528:	73 5b                	jae    800585 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80052a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80052e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800532:	85 db                	test   %ebx,%ebx
  800534:	7e 0e                	jle    800544 <print_num+0x47>
            putch(padc, put_arg);
  800536:	4c 89 ee             	mov    %r13,%rsi
  800539:	44 89 f7             	mov    %r14d,%edi
  80053c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80053f:	83 eb 01             	sub    $0x1,%ebx
  800542:	75 f2                	jne    800536 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800544:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800548:	48 b9 c8 40 80 00 00 	movabs $0x8040c8,%rcx
  80054f:	00 00 00 
  800552:	48 b8 b7 40 80 00 00 	movabs $0x8040b7,%rax
  800559:	00 00 00 
  80055c:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800560:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800564:	ba 00 00 00 00       	mov    $0x0,%edx
  800569:	49 f7 f7             	div    %r15
  80056c:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800570:	4c 89 ee             	mov    %r13,%rsi
  800573:	41 ff d4             	call   *%r12
}
  800576:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80057a:	5b                   	pop    %rbx
  80057b:	41 5c                	pop    %r12
  80057d:	41 5d                	pop    %r13
  80057f:	41 5e                	pop    %r14
  800581:	41 5f                	pop    %r15
  800583:	5d                   	pop    %rbp
  800584:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800585:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
  80058e:	49 f7 f7             	div    %r15
  800591:	48 83 ec 08          	sub    $0x8,%rsp
  800595:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800599:	52                   	push   %rdx
  80059a:	45 0f be c9          	movsbl %r9b,%r9d
  80059e:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8005a2:	48 89 c2             	mov    %rax,%rdx
  8005a5:	48 b8 fd 04 80 00 00 	movabs $0x8004fd,%rax
  8005ac:	00 00 00 
  8005af:	ff d0                	call   *%rax
  8005b1:	48 83 c4 10          	add    $0x10,%rsp
  8005b5:	eb 8d                	jmp    800544 <print_num+0x47>

00000000008005b7 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8005b7:	f3 0f 1e fa          	endbr64
    state->count++;
  8005bb:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8005bf:	48 8b 06             	mov    (%rsi),%rax
  8005c2:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8005c6:	73 0a                	jae    8005d2 <sprintputch+0x1b>
        *state->start++ = ch;
  8005c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8005cc:	48 89 16             	mov    %rdx,(%rsi)
  8005cf:	40 88 38             	mov    %dil,(%rax)
    }
}
  8005d2:	c3                   	ret

00000000008005d3 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8005d3:	f3 0f 1e fa          	endbr64
  8005d7:	55                   	push   %rbp
  8005d8:	48 89 e5             	mov    %rsp,%rbp
  8005db:	48 83 ec 50          	sub    $0x50,%rsp
  8005df:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005e3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005e7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8005eb:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8005f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005fa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005fe:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800602:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800606:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  80060d:	00 00 00 
  800610:	ff d0                	call   *%rax
}
  800612:	c9                   	leave
  800613:	c3                   	ret

0000000000800614 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800614:	f3 0f 1e fa          	endbr64
  800618:	55                   	push   %rbp
  800619:	48 89 e5             	mov    %rsp,%rbp
  80061c:	41 57                	push   %r15
  80061e:	41 56                	push   %r14
  800620:	41 55                	push   %r13
  800622:	41 54                	push   %r12
  800624:	53                   	push   %rbx
  800625:	48 83 ec 38          	sub    $0x38,%rsp
  800629:	49 89 fe             	mov    %rdi,%r14
  80062c:	49 89 f5             	mov    %rsi,%r13
  80062f:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800632:	48 8b 01             	mov    (%rcx),%rax
  800635:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800639:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80063d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800641:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800645:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800649:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80064d:	0f b6 3b             	movzbl (%rbx),%edi
  800650:	40 80 ff 25          	cmp    $0x25,%dil
  800654:	74 18                	je     80066e <vprintfmt+0x5a>
            if (!ch) return;
  800656:	40 84 ff             	test   %dil,%dil
  800659:	0f 84 b2 06 00 00    	je     800d11 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80065f:	40 0f b6 ff          	movzbl %dil,%edi
  800663:	4c 89 ee             	mov    %r13,%rsi
  800666:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800669:	4c 89 e3             	mov    %r12,%rbx
  80066c:	eb db                	jmp    800649 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80066e:	be 00 00 00 00       	mov    $0x0,%esi
  800673:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80067c:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800682:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800689:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80068d:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800692:	41 0f b6 04 24       	movzbl (%r12),%eax
  800697:	88 45 a0             	mov    %al,-0x60(%rbp)
  80069a:	83 e8 23             	sub    $0x23,%eax
  80069d:	3c 57                	cmp    $0x57,%al
  80069f:	0f 87 52 06 00 00    	ja     800cf7 <vprintfmt+0x6e3>
  8006a5:	0f b6 c0             	movzbl %al,%eax
  8006a8:	48 b9 60 45 80 00 00 	movabs $0x804560,%rcx
  8006af:	00 00 00 
  8006b2:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8006b6:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8006b9:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8006bd:	eb ce                	jmp    80068d <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8006bf:	49 89 dc             	mov    %rbx,%r12
  8006c2:	be 01 00 00 00       	mov    $0x1,%esi
  8006c7:	eb c4                	jmp    80068d <vprintfmt+0x79>
            padc = ch;
  8006c9:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8006cd:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8006d0:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8006d3:	eb b8                	jmp    80068d <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8006d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d8:	83 f8 2f             	cmp    $0x2f,%eax
  8006db:	77 24                	ja     800701 <vprintfmt+0xed>
  8006dd:	89 c1                	mov    %eax,%ecx
  8006df:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8006e3:	83 c0 08             	add    $0x8,%eax
  8006e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e9:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8006ec:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8006ef:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006f3:	79 98                	jns    80068d <vprintfmt+0x79>
                width = precision;
  8006f5:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8006f9:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8006ff:	eb 8c                	jmp    80068d <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800701:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800705:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800709:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070d:	eb da                	jmp    8006e9 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80070f:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800714:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800718:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80071e:	3c 39                	cmp    $0x39,%al
  800720:	77 1c                	ja     80073e <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800722:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800726:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80072a:	0f b6 c0             	movzbl %al,%eax
  80072d:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800732:	0f b6 03             	movzbl (%rbx),%eax
  800735:	3c 39                	cmp    $0x39,%al
  800737:	76 e9                	jbe    800722 <vprintfmt+0x10e>
        process_precision:
  800739:	49 89 dc             	mov    %rbx,%r12
  80073c:	eb b1                	jmp    8006ef <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80073e:	49 89 dc             	mov    %rbx,%r12
  800741:	eb ac                	jmp    8006ef <vprintfmt+0xdb>
            width = MAX(0, width);
  800743:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800746:	85 c9                	test   %ecx,%ecx
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
  80074d:	0f 49 c1             	cmovns %ecx,%eax
  800750:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800753:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800756:	e9 32 ff ff ff       	jmp    80068d <vprintfmt+0x79>
            lflag++;
  80075b:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80075e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800761:	e9 27 ff ff ff       	jmp    80068d <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800766:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800769:	83 f8 2f             	cmp    $0x2f,%eax
  80076c:	77 19                	ja     800787 <vprintfmt+0x173>
  80076e:	89 c2                	mov    %eax,%edx
  800770:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800774:	83 c0 08             	add    $0x8,%eax
  800777:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80077a:	8b 3a                	mov    (%rdx),%edi
  80077c:	4c 89 ee             	mov    %r13,%rsi
  80077f:	41 ff d6             	call   *%r14
            break;
  800782:	e9 c2 fe ff ff       	jmp    800649 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800787:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80078b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80078f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800793:	eb e5                	jmp    80077a <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800795:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800798:	83 f8 2f             	cmp    $0x2f,%eax
  80079b:	77 5a                	ja     8007f7 <vprintfmt+0x1e3>
  80079d:	89 c2                	mov    %eax,%edx
  80079f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a3:	83 c0 08             	add    $0x8,%eax
  8007a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8007a9:	8b 02                	mov    (%rdx),%eax
  8007ab:	89 c1                	mov    %eax,%ecx
  8007ad:	f7 d9                	neg    %ecx
  8007af:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8007b2:	83 f9 13             	cmp    $0x13,%ecx
  8007b5:	7f 4e                	jg     800805 <vprintfmt+0x1f1>
  8007b7:	48 63 c1             	movslq %ecx,%rax
  8007ba:	48 ba 20 48 80 00 00 	movabs $0x804820,%rdx
  8007c1:	00 00 00 
  8007c4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8007c8:	48 85 c0             	test   %rax,%rax
  8007cb:	74 38                	je     800805 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8007cd:	48 89 c1             	mov    %rax,%rcx
  8007d0:	48 ba e2 42 80 00 00 	movabs $0x8042e2,%rdx
  8007d7:	00 00 00 
  8007da:	4c 89 ee             	mov    %r13,%rsi
  8007dd:	4c 89 f7             	mov    %r14,%rdi
  8007e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e5:	49 b8 d3 05 80 00 00 	movabs $0x8005d3,%r8
  8007ec:	00 00 00 
  8007ef:	41 ff d0             	call   *%r8
  8007f2:	e9 52 fe ff ff       	jmp    800649 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8007f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800803:	eb a4                	jmp    8007a9 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800805:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  80080c:	00 00 00 
  80080f:	4c 89 ee             	mov    %r13,%rsi
  800812:	4c 89 f7             	mov    %r14,%rdi
  800815:	b8 00 00 00 00       	mov    $0x0,%eax
  80081a:	49 b8 d3 05 80 00 00 	movabs $0x8005d3,%r8
  800821:	00 00 00 
  800824:	41 ff d0             	call   *%r8
  800827:	e9 1d fe ff ff       	jmp    800649 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80082c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082f:	83 f8 2f             	cmp    $0x2f,%eax
  800832:	77 6c                	ja     8008a0 <vprintfmt+0x28c>
  800834:	89 c2                	mov    %eax,%edx
  800836:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80083a:	83 c0 08             	add    $0x8,%eax
  80083d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800840:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800843:	48 85 d2             	test   %rdx,%rdx
  800846:	48 b8 d9 40 80 00 00 	movabs $0x8040d9,%rax
  80084d:	00 00 00 
  800850:	48 0f 45 c2          	cmovne %rdx,%rax
  800854:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800858:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80085c:	7e 06                	jle    800864 <vprintfmt+0x250>
  80085e:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800862:	75 4a                	jne    8008ae <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800864:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800868:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80086c:	0f b6 00             	movzbl (%rax),%eax
  80086f:	84 c0                	test   %al,%al
  800871:	0f 85 9a 00 00 00    	jne    800911 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800877:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80087a:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80087e:	85 c0                	test   %eax,%eax
  800880:	0f 8e c3 fd ff ff    	jle    800649 <vprintfmt+0x35>
  800886:	4c 89 ee             	mov    %r13,%rsi
  800889:	bf 20 00 00 00       	mov    $0x20,%edi
  80088e:	41 ff d6             	call   *%r14
  800891:	41 83 ec 01          	sub    $0x1,%r12d
  800895:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800899:	75 eb                	jne    800886 <vprintfmt+0x272>
  80089b:	e9 a9 fd ff ff       	jmp    800649 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8008a0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ac:	eb 92                	jmp    800840 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8008ae:	49 63 f7             	movslq %r15d,%rsi
  8008b1:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8008b5:	48 b8 d7 0d 80 00 00 	movabs $0x800dd7,%rax
  8008bc:	00 00 00 
  8008bf:	ff d0                	call   *%rax
  8008c1:	48 89 c2             	mov    %rax,%rdx
  8008c4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008c7:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8008c9:	8d 70 ff             	lea    -0x1(%rax),%esi
  8008cc:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	7e 91                	jle    800864 <vprintfmt+0x250>
  8008d3:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8008d8:	4c 89 ee             	mov    %r13,%rsi
  8008db:	44 89 e7             	mov    %r12d,%edi
  8008de:	41 ff d6             	call   *%r14
  8008e1:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8008e5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008e8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8008eb:	75 eb                	jne    8008d8 <vprintfmt+0x2c4>
  8008ed:	e9 72 ff ff ff       	jmp    800864 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8008f2:	0f b6 f8             	movzbl %al,%edi
  8008f5:	4c 89 ee             	mov    %r13,%rsi
  8008f8:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008fb:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8008ff:	49 83 c4 01          	add    $0x1,%r12
  800903:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800909:	84 c0                	test   %al,%al
  80090b:	0f 84 66 ff ff ff    	je     800877 <vprintfmt+0x263>
  800911:	45 85 ff             	test   %r15d,%r15d
  800914:	78 0a                	js     800920 <vprintfmt+0x30c>
  800916:	41 83 ef 01          	sub    $0x1,%r15d
  80091a:	0f 88 57 ff ff ff    	js     800877 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800920:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800924:	74 cc                	je     8008f2 <vprintfmt+0x2de>
  800926:	8d 50 e0             	lea    -0x20(%rax),%edx
  800929:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80092e:	80 fa 5e             	cmp    $0x5e,%dl
  800931:	77 c2                	ja     8008f5 <vprintfmt+0x2e1>
  800933:	eb bd                	jmp    8008f2 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800935:	40 84 f6             	test   %sil,%sil
  800938:	75 26                	jne    800960 <vprintfmt+0x34c>
    switch (lflag) {
  80093a:	85 d2                	test   %edx,%edx
  80093c:	74 59                	je     800997 <vprintfmt+0x383>
  80093e:	83 fa 01             	cmp    $0x1,%edx
  800941:	74 7b                	je     8009be <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800943:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800946:	83 f8 2f             	cmp    $0x2f,%eax
  800949:	0f 87 96 00 00 00    	ja     8009e5 <vprintfmt+0x3d1>
  80094f:	89 c2                	mov    %eax,%edx
  800951:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800955:	83 c0 08             	add    $0x8,%eax
  800958:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095b:	4c 8b 22             	mov    (%rdx),%r12
  80095e:	eb 17                	jmp    800977 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800960:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800963:	83 f8 2f             	cmp    $0x2f,%eax
  800966:	77 21                	ja     800989 <vprintfmt+0x375>
  800968:	89 c2                	mov    %eax,%edx
  80096a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80096e:	83 c0 08             	add    $0x8,%eax
  800971:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800974:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800977:	4d 85 e4             	test   %r12,%r12
  80097a:	78 7a                	js     8009f6 <vprintfmt+0x3e2>
            num = i;
  80097c:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80097f:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800984:	e9 50 02 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800989:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800991:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800995:	eb dd                	jmp    800974 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800997:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099a:	83 f8 2f             	cmp    $0x2f,%eax
  80099d:	77 11                	ja     8009b0 <vprintfmt+0x39c>
  80099f:	89 c2                	mov    %eax,%edx
  8009a1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a5:	83 c0 08             	add    $0x8,%eax
  8009a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ab:	4c 63 22             	movslq (%rdx),%r12
  8009ae:	eb c7                	jmp    800977 <vprintfmt+0x363>
  8009b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009bc:	eb ed                	jmp    8009ab <vprintfmt+0x397>
        return va_arg(*ap, long);
  8009be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c1:	83 f8 2f             	cmp    $0x2f,%eax
  8009c4:	77 11                	ja     8009d7 <vprintfmt+0x3c3>
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009cc:	83 c0 08             	add    $0x8,%eax
  8009cf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d2:	4c 8b 22             	mov    (%rdx),%r12
  8009d5:	eb a0                	jmp    800977 <vprintfmt+0x363>
  8009d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009db:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e3:	eb ed                	jmp    8009d2 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8009e5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f1:	e9 65 ff ff ff       	jmp    80095b <vprintfmt+0x347>
                putch('-', put_arg);
  8009f6:	4c 89 ee             	mov    %r13,%rsi
  8009f9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009fe:	41 ff d6             	call   *%r14
                i = -i;
  800a01:	49 f7 dc             	neg    %r12
  800a04:	e9 73 ff ff ff       	jmp    80097c <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800a09:	40 84 f6             	test   %sil,%sil
  800a0c:	75 32                	jne    800a40 <vprintfmt+0x42c>
    switch (lflag) {
  800a0e:	85 d2                	test   %edx,%edx
  800a10:	74 5d                	je     800a6f <vprintfmt+0x45b>
  800a12:	83 fa 01             	cmp    $0x1,%edx
  800a15:	0f 84 82 00 00 00    	je     800a9d <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800a1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1e:	83 f8 2f             	cmp    $0x2f,%eax
  800a21:	0f 87 a5 00 00 00    	ja     800acc <vprintfmt+0x4b8>
  800a27:	89 c2                	mov    %eax,%edx
  800a29:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2d:	83 c0 08             	add    $0x8,%eax
  800a30:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a33:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a36:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a3b:	e9 99 01 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a43:	83 f8 2f             	cmp    $0x2f,%eax
  800a46:	77 19                	ja     800a61 <vprintfmt+0x44d>
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4e:	83 c0 08             	add    $0x8,%eax
  800a51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a54:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a57:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a5c:	e9 78 01 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
  800a61:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a65:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a69:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6d:	eb e5                	jmp    800a54 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	83 f8 2f             	cmp    $0x2f,%eax
  800a75:	77 18                	ja     800a8f <vprintfmt+0x47b>
  800a77:	89 c2                	mov    %eax,%edx
  800a79:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7d:	83 c0 08             	add    $0x8,%eax
  800a80:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a83:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800a85:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800a8a:	e9 4a 01 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
  800a8f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a93:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a97:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9b:	eb e6                	jmp    800a83 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa0:	83 f8 2f             	cmp    $0x2f,%eax
  800aa3:	77 19                	ja     800abe <vprintfmt+0x4aa>
  800aa5:	89 c2                	mov    %eax,%edx
  800aa7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aab:	83 c0 08             	add    $0x8,%eax
  800aae:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab1:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ab4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800ab9:	e9 1b 01 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
  800abe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aca:	eb e5                	jmp    800ab1 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800acc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad8:	e9 56 ff ff ff       	jmp    800a33 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800add:	40 84 f6             	test   %sil,%sil
  800ae0:	75 2e                	jne    800b10 <vprintfmt+0x4fc>
    switch (lflag) {
  800ae2:	85 d2                	test   %edx,%edx
  800ae4:	74 59                	je     800b3f <vprintfmt+0x52b>
  800ae6:	83 fa 01             	cmp    $0x1,%edx
  800ae9:	74 7f                	je     800b6a <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	83 f8 2f             	cmp    $0x2f,%eax
  800af1:	0f 87 9f 00 00 00    	ja     800b96 <vprintfmt+0x582>
  800af7:	89 c2                	mov    %eax,%edx
  800af9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800afd:	83 c0 08             	add    $0x8,%eax
  800b00:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b03:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b06:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b0b:	e9 c9 00 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b13:	83 f8 2f             	cmp    $0x2f,%eax
  800b16:	77 19                	ja     800b31 <vprintfmt+0x51d>
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b1e:	83 c0 08             	add    $0x8,%eax
  800b21:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b24:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b27:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b2c:	e9 a8 00 00 00       	jmp    800bd9 <vprintfmt+0x5c5>
  800b31:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b35:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b39:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b3d:	eb e5                	jmp    800b24 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800b3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b42:	83 f8 2f             	cmp    $0x2f,%eax
  800b45:	77 15                	ja     800b5c <vprintfmt+0x548>
  800b47:	89 c2                	mov    %eax,%edx
  800b49:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b4d:	83 c0 08             	add    $0x8,%eax
  800b50:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b53:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800b55:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800b5a:	eb 7d                	jmp    800bd9 <vprintfmt+0x5c5>
  800b5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b60:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b68:	eb e9                	jmp    800b53 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800b6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6d:	83 f8 2f             	cmp    $0x2f,%eax
  800b70:	77 16                	ja     800b88 <vprintfmt+0x574>
  800b72:	89 c2                	mov    %eax,%edx
  800b74:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b78:	83 c0 08             	add    $0x8,%eax
  800b7b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b7e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b81:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800b86:	eb 51                	jmp    800bd9 <vprintfmt+0x5c5>
  800b88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b8c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b90:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b94:	eb e8                	jmp    800b7e <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800b96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba2:	e9 5c ff ff ff       	jmp    800b03 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800ba7:	4c 89 ee             	mov    %r13,%rsi
  800baa:	bf 30 00 00 00       	mov    $0x30,%edi
  800baf:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800bb2:	4c 89 ee             	mov    %r13,%rsi
  800bb5:	bf 78 00 00 00       	mov    $0x78,%edi
  800bba:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 2f             	cmp    $0x2f,%eax
  800bc3:	77 47                	ja     800c0c <vprintfmt+0x5f8>
  800bc5:	89 c2                	mov    %eax,%edx
  800bc7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bcb:	83 c0 08             	add    $0x8,%eax
  800bce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd1:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bd4:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800bd9:	48 83 ec 08          	sub    $0x8,%rsp
  800bdd:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800be1:	0f 94 c0             	sete   %al
  800be4:	0f b6 c0             	movzbl %al,%eax
  800be7:	50                   	push   %rax
  800be8:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800bed:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800bf1:	4c 89 ee             	mov    %r13,%rsi
  800bf4:	4c 89 f7             	mov    %r14,%rdi
  800bf7:	48 b8 fd 04 80 00 00 	movabs $0x8004fd,%rax
  800bfe:	00 00 00 
  800c01:	ff d0                	call   *%rax
            break;
  800c03:	48 83 c4 10          	add    $0x10,%rsp
  800c07:	e9 3d fa ff ff       	jmp    800649 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800c0c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c10:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c14:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c18:	eb b7                	jmp    800bd1 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800c1a:	40 84 f6             	test   %sil,%sil
  800c1d:	75 2b                	jne    800c4a <vprintfmt+0x636>
    switch (lflag) {
  800c1f:	85 d2                	test   %edx,%edx
  800c21:	74 56                	je     800c79 <vprintfmt+0x665>
  800c23:	83 fa 01             	cmp    $0x1,%edx
  800c26:	74 7f                	je     800ca7 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800c28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2b:	83 f8 2f             	cmp    $0x2f,%eax
  800c2e:	0f 87 a2 00 00 00    	ja     800cd6 <vprintfmt+0x6c2>
  800c34:	89 c2                	mov    %eax,%edx
  800c36:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c3a:	83 c0 08             	add    $0x8,%eax
  800c3d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c40:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c43:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c48:	eb 8f                	jmp    800bd9 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4d:	83 f8 2f             	cmp    $0x2f,%eax
  800c50:	77 19                	ja     800c6b <vprintfmt+0x657>
  800c52:	89 c2                	mov    %eax,%edx
  800c54:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c58:	83 c0 08             	add    $0x8,%eax
  800c5b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c5e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c61:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c66:	e9 6e ff ff ff       	jmp    800bd9 <vprintfmt+0x5c5>
  800c6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c73:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c77:	eb e5                	jmp    800c5e <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800c79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7c:	83 f8 2f             	cmp    $0x2f,%eax
  800c7f:	77 18                	ja     800c99 <vprintfmt+0x685>
  800c81:	89 c2                	mov    %eax,%edx
  800c83:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c87:	83 c0 08             	add    $0x8,%eax
  800c8a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c8d:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800c8f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800c94:	e9 40 ff ff ff       	jmp    800bd9 <vprintfmt+0x5c5>
  800c99:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ca1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca5:	eb e6                	jmp    800c8d <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800ca7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800caa:	83 f8 2f             	cmp    $0x2f,%eax
  800cad:	77 19                	ja     800cc8 <vprintfmt+0x6b4>
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb5:	83 c0 08             	add    $0x8,%eax
  800cb8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cbb:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cbe:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800cc3:	e9 11 ff ff ff       	jmp    800bd9 <vprintfmt+0x5c5>
  800cc8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ccc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cd0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd4:	eb e5                	jmp    800cbb <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800cd6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cda:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cde:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ce2:	e9 59 ff ff ff       	jmp    800c40 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800ce7:	4c 89 ee             	mov    %r13,%rsi
  800cea:	bf 25 00 00 00       	mov    $0x25,%edi
  800cef:	41 ff d6             	call   *%r14
            break;
  800cf2:	e9 52 f9 ff ff       	jmp    800649 <vprintfmt+0x35>
            putch('%', put_arg);
  800cf7:	4c 89 ee             	mov    %r13,%rsi
  800cfa:	bf 25 00 00 00       	mov    $0x25,%edi
  800cff:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800d02:	48 83 eb 01          	sub    $0x1,%rbx
  800d06:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800d0a:	75 f6                	jne    800d02 <vprintfmt+0x6ee>
  800d0c:	e9 38 f9 ff ff       	jmp    800649 <vprintfmt+0x35>
}
  800d11:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d15:	5b                   	pop    %rbx
  800d16:	41 5c                	pop    %r12
  800d18:	41 5d                	pop    %r13
  800d1a:	41 5e                	pop    %r14
  800d1c:	41 5f                	pop    %r15
  800d1e:	5d                   	pop    %rbp
  800d1f:	c3                   	ret

0000000000800d20 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d20:	f3 0f 1e fa          	endbr64
  800d24:	55                   	push   %rbp
  800d25:	48 89 e5             	mov    %rsp,%rbp
  800d28:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d30:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800d40:	48 85 ff             	test   %rdi,%rdi
  800d43:	74 2b                	je     800d70 <vsnprintf+0x50>
  800d45:	48 85 f6             	test   %rsi,%rsi
  800d48:	74 26                	je     800d70 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800d4a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d4e:	48 bf b7 05 80 00 00 	movabs $0x8005b7,%rdi
  800d55:	00 00 00 
  800d58:	48 b8 14 06 80 00 00 	movabs $0x800614,%rax
  800d5f:	00 00 00 
  800d62:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d68:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800d6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800d6e:	c9                   	leave
  800d6f:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800d70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d75:	eb f7                	jmp    800d6e <vsnprintf+0x4e>

0000000000800d77 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800d77:	f3 0f 1e fa          	endbr64
  800d7b:	55                   	push   %rbp
  800d7c:	48 89 e5             	mov    %rsp,%rbp
  800d7f:	48 83 ec 50          	sub    $0x50,%rsp
  800d83:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d87:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d8b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800d8f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800d96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d9a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d9e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800da2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800da6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800daa:	48 b8 20 0d 80 00 00 	movabs $0x800d20,%rax
  800db1:	00 00 00 
  800db4:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800db6:	c9                   	leave
  800db7:	c3                   	ret

0000000000800db8 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800db8:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800dbc:	80 3f 00             	cmpb   $0x0,(%rdi)
  800dbf:	74 10                	je     800dd1 <strlen+0x19>
    size_t n = 0;
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800dc6:	48 83 c0 01          	add    $0x1,%rax
  800dca:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800dce:	75 f6                	jne    800dc6 <strlen+0xe>
  800dd0:	c3                   	ret
    size_t n = 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800dd6:	c3                   	ret

0000000000800dd7 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800dd7:	f3 0f 1e fa          	endbr64
  800ddb:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800dde:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800de3:	48 85 f6             	test   %rsi,%rsi
  800de6:	74 10                	je     800df8 <strnlen+0x21>
  800de8:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800dec:	74 0b                	je     800df9 <strnlen+0x22>
  800dee:	48 83 c2 01          	add    $0x1,%rdx
  800df2:	48 39 d0             	cmp    %rdx,%rax
  800df5:	75 f1                	jne    800de8 <strnlen+0x11>
  800df7:	c3                   	ret
  800df8:	c3                   	ret
  800df9:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800dfc:	c3                   	ret

0000000000800dfd <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800dfd:	f3 0f 1e fa          	endbr64
  800e01:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e04:	ba 00 00 00 00       	mov    $0x0,%edx
  800e09:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800e0d:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800e10:	48 83 c2 01          	add    $0x1,%rdx
  800e14:	84 c9                	test   %cl,%cl
  800e16:	75 f1                	jne    800e09 <strcpy+0xc>
        ;
    return res;
}
  800e18:	c3                   	ret

0000000000800e19 <strcat>:

char *
strcat(char *dst, const char *src) {
  800e19:	f3 0f 1e fa          	endbr64
  800e1d:	55                   	push   %rbp
  800e1e:	48 89 e5             	mov    %rsp,%rbp
  800e21:	41 54                	push   %r12
  800e23:	53                   	push   %rbx
  800e24:	48 89 fb             	mov    %rdi,%rbx
  800e27:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e2a:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e36:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e3a:	4c 89 e6             	mov    %r12,%rsi
  800e3d:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  800e44:	00 00 00 
  800e47:	ff d0                	call   *%rax
    return dst;
}
  800e49:	48 89 d8             	mov    %rbx,%rax
  800e4c:	5b                   	pop    %rbx
  800e4d:	41 5c                	pop    %r12
  800e4f:	5d                   	pop    %rbp
  800e50:	c3                   	ret

0000000000800e51 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e51:	f3 0f 1e fa          	endbr64
  800e55:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800e58:	48 85 d2             	test   %rdx,%rdx
  800e5b:	74 1f                	je     800e7c <strncpy+0x2b>
  800e5d:	48 01 fa             	add    %rdi,%rdx
  800e60:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800e63:	48 83 c1 01          	add    $0x1,%rcx
  800e67:	44 0f b6 06          	movzbl (%rsi),%r8d
  800e6b:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e6f:	41 80 f8 01          	cmp    $0x1,%r8b
  800e73:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800e77:	48 39 ca             	cmp    %rcx,%rdx
  800e7a:	75 e7                	jne    800e63 <strncpy+0x12>
    }
    return ret;
}
  800e7c:	c3                   	ret

0000000000800e7d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800e7d:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800e81:	48 89 f8             	mov    %rdi,%rax
  800e84:	48 85 d2             	test   %rdx,%rdx
  800e87:	74 24                	je     800ead <strlcpy+0x30>
        while (--size > 0 && *src)
  800e89:	48 83 ea 01          	sub    $0x1,%rdx
  800e8d:	74 1b                	je     800eaa <strlcpy+0x2d>
  800e8f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e93:	0f b6 16             	movzbl (%rsi),%edx
  800e96:	84 d2                	test   %dl,%dl
  800e98:	74 10                	je     800eaa <strlcpy+0x2d>
            *dst++ = *src++;
  800e9a:	48 83 c6 01          	add    $0x1,%rsi
  800e9e:	48 83 c0 01          	add    $0x1,%rax
  800ea2:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ea5:	48 39 c8             	cmp    %rcx,%rax
  800ea8:	75 e9                	jne    800e93 <strlcpy+0x16>
        *dst = '\0';
  800eaa:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800ead:	48 29 f8             	sub    %rdi,%rax
}
  800eb0:	c3                   	ret

0000000000800eb1 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800eb1:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800eb5:	0f b6 07             	movzbl (%rdi),%eax
  800eb8:	84 c0                	test   %al,%al
  800eba:	74 13                	je     800ecf <strcmp+0x1e>
  800ebc:	38 06                	cmp    %al,(%rsi)
  800ebe:	75 0f                	jne    800ecf <strcmp+0x1e>
  800ec0:	48 83 c7 01          	add    $0x1,%rdi
  800ec4:	48 83 c6 01          	add    $0x1,%rsi
  800ec8:	0f b6 07             	movzbl (%rdi),%eax
  800ecb:	84 c0                	test   %al,%al
  800ecd:	75 ed                	jne    800ebc <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800ecf:	0f b6 c0             	movzbl %al,%eax
  800ed2:	0f b6 16             	movzbl (%rsi),%edx
  800ed5:	29 d0                	sub    %edx,%eax
}
  800ed7:	c3                   	ret

0000000000800ed8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800ed8:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800edc:	48 85 d2             	test   %rdx,%rdx
  800edf:	74 1f                	je     800f00 <strncmp+0x28>
  800ee1:	0f b6 07             	movzbl (%rdi),%eax
  800ee4:	84 c0                	test   %al,%al
  800ee6:	74 1e                	je     800f06 <strncmp+0x2e>
  800ee8:	3a 06                	cmp    (%rsi),%al
  800eea:	75 1a                	jne    800f06 <strncmp+0x2e>
  800eec:	48 83 c7 01          	add    $0x1,%rdi
  800ef0:	48 83 c6 01          	add    $0x1,%rsi
  800ef4:	48 83 ea 01          	sub    $0x1,%rdx
  800ef8:	75 e7                	jne    800ee1 <strncmp+0x9>

    if (!n) return 0;
  800efa:	b8 00 00 00 00       	mov    $0x0,%eax
  800eff:	c3                   	ret
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f06:	0f b6 07             	movzbl (%rdi),%eax
  800f09:	0f b6 16             	movzbl (%rsi),%edx
  800f0c:	29 d0                	sub    %edx,%eax
}
  800f0e:	c3                   	ret

0000000000800f0f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800f0f:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800f13:	0f b6 17             	movzbl (%rdi),%edx
  800f16:	84 d2                	test   %dl,%dl
  800f18:	74 18                	je     800f32 <strchr+0x23>
        if (*str == c) {
  800f1a:	0f be d2             	movsbl %dl,%edx
  800f1d:	39 f2                	cmp    %esi,%edx
  800f1f:	74 17                	je     800f38 <strchr+0x29>
    for (; *str; str++) {
  800f21:	48 83 c7 01          	add    $0x1,%rdi
  800f25:	0f b6 17             	movzbl (%rdi),%edx
  800f28:	84 d2                	test   %dl,%dl
  800f2a:	75 ee                	jne    800f1a <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f31:	c3                   	ret
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
  800f37:	c3                   	ret
            return (char *)str;
  800f38:	48 89 f8             	mov    %rdi,%rax
}
  800f3b:	c3                   	ret

0000000000800f3c <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800f3c:	f3 0f 1e fa          	endbr64
  800f40:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800f43:	0f b6 17             	movzbl (%rdi),%edx
  800f46:	84 d2                	test   %dl,%dl
  800f48:	74 13                	je     800f5d <strfind+0x21>
  800f4a:	0f be d2             	movsbl %dl,%edx
  800f4d:	39 f2                	cmp    %esi,%edx
  800f4f:	74 0b                	je     800f5c <strfind+0x20>
  800f51:	48 83 c0 01          	add    $0x1,%rax
  800f55:	0f b6 10             	movzbl (%rax),%edx
  800f58:	84 d2                	test   %dl,%dl
  800f5a:	75 ee                	jne    800f4a <strfind+0xe>
        ;
    return (char *)str;
}
  800f5c:	c3                   	ret
  800f5d:	c3                   	ret

0000000000800f5e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800f5e:	f3 0f 1e fa          	endbr64
  800f62:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800f65:	48 89 f8             	mov    %rdi,%rax
  800f68:	48 f7 d8             	neg    %rax
  800f6b:	83 e0 07             	and    $0x7,%eax
  800f6e:	49 89 d1             	mov    %rdx,%r9
  800f71:	49 29 c1             	sub    %rax,%r9
  800f74:	78 36                	js     800fac <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800f76:	40 0f b6 c6          	movzbl %sil,%eax
  800f7a:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800f81:	01 01 01 
  800f84:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800f88:	40 f6 c7 07          	test   $0x7,%dil
  800f8c:	75 38                	jne    800fc6 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800f8e:	4c 89 c9             	mov    %r9,%rcx
  800f91:	48 c1 f9 03          	sar    $0x3,%rcx
  800f95:	74 0c                	je     800fa3 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800f97:	fc                   	cld
  800f98:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800f9b:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800f9f:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800fa3:	4d 85 c9             	test   %r9,%r9
  800fa6:	75 45                	jne    800fed <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800fa8:	4c 89 c0             	mov    %r8,%rax
  800fab:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800fac:	48 85 d2             	test   %rdx,%rdx
  800faf:	74 f7                	je     800fa8 <memset+0x4a>
  800fb1:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800fb4:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800fb7:	48 83 c0 01          	add    $0x1,%rax
  800fbb:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800fbf:	48 39 c2             	cmp    %rax,%rdx
  800fc2:	75 f3                	jne    800fb7 <memset+0x59>
  800fc4:	eb e2                	jmp    800fa8 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800fc6:	40 f6 c7 01          	test   $0x1,%dil
  800fca:	74 06                	je     800fd2 <memset+0x74>
  800fcc:	88 07                	mov    %al,(%rdi)
  800fce:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800fd2:	40 f6 c7 02          	test   $0x2,%dil
  800fd6:	74 07                	je     800fdf <memset+0x81>
  800fd8:	66 89 07             	mov    %ax,(%rdi)
  800fdb:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fdf:	40 f6 c7 04          	test   $0x4,%dil
  800fe3:	74 a9                	je     800f8e <memset+0x30>
  800fe5:	89 07                	mov    %eax,(%rdi)
  800fe7:	48 83 c7 04          	add    $0x4,%rdi
  800feb:	eb a1                	jmp    800f8e <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fed:	41 f6 c1 04          	test   $0x4,%r9b
  800ff1:	74 1b                	je     80100e <memset+0xb0>
  800ff3:	89 07                	mov    %eax,(%rdi)
  800ff5:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ff9:	41 f6 c1 02          	test   $0x2,%r9b
  800ffd:	74 07                	je     801006 <memset+0xa8>
  800fff:	66 89 07             	mov    %ax,(%rdi)
  801002:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801006:	41 f6 c1 01          	test   $0x1,%r9b
  80100a:	74 9c                	je     800fa8 <memset+0x4a>
  80100c:	eb 06                	jmp    801014 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80100e:	41 f6 c1 02          	test   $0x2,%r9b
  801012:	75 eb                	jne    800fff <memset+0xa1>
        if (ni & 1) *ptr = k;
  801014:	88 07                	mov    %al,(%rdi)
  801016:	eb 90                	jmp    800fa8 <memset+0x4a>

0000000000801018 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801018:	f3 0f 1e fa          	endbr64
  80101c:	48 89 f8             	mov    %rdi,%rax
  80101f:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801022:	48 39 fe             	cmp    %rdi,%rsi
  801025:	73 3b                	jae    801062 <memmove+0x4a>
  801027:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80102b:	48 39 d7             	cmp    %rdx,%rdi
  80102e:	73 32                	jae    801062 <memmove+0x4a>
        s += n;
        d += n;
  801030:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801034:	48 89 d6             	mov    %rdx,%rsi
  801037:	48 09 fe             	or     %rdi,%rsi
  80103a:	48 09 ce             	or     %rcx,%rsi
  80103d:	40 f6 c6 07          	test   $0x7,%sil
  801041:	75 12                	jne    801055 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801043:	48 83 ef 08          	sub    $0x8,%rdi
  801047:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80104b:	48 c1 e9 03          	shr    $0x3,%rcx
  80104f:	fd                   	std
  801050:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801053:	fc                   	cld
  801054:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801055:	48 83 ef 01          	sub    $0x1,%rdi
  801059:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80105d:	fd                   	std
  80105e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801060:	eb f1                	jmp    801053 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801062:	48 89 f2             	mov    %rsi,%rdx
  801065:	48 09 c2             	or     %rax,%rdx
  801068:	48 09 ca             	or     %rcx,%rdx
  80106b:	f6 c2 07             	test   $0x7,%dl
  80106e:	75 0c                	jne    80107c <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801070:	48 c1 e9 03          	shr    $0x3,%rcx
  801074:	48 89 c7             	mov    %rax,%rdi
  801077:	fc                   	cld
  801078:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80107b:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80107c:	48 89 c7             	mov    %rax,%rdi
  80107f:	fc                   	cld
  801080:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801082:	c3                   	ret

0000000000801083 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801083:	f3 0f 1e fa          	endbr64
  801087:	55                   	push   %rbp
  801088:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80108b:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  801092:	00 00 00 
  801095:	ff d0                	call   *%rax
}
  801097:	5d                   	pop    %rbp
  801098:	c3                   	ret

0000000000801099 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801099:	f3 0f 1e fa          	endbr64
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
  8010a1:	41 57                	push   %r15
  8010a3:	41 56                	push   %r14
  8010a5:	41 55                	push   %r13
  8010a7:	41 54                	push   %r12
  8010a9:	53                   	push   %rbx
  8010aa:	48 83 ec 08          	sub    $0x8,%rsp
  8010ae:	49 89 fe             	mov    %rdi,%r14
  8010b1:	49 89 f7             	mov    %rsi,%r15
  8010b4:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8010b7:	48 89 f7             	mov    %rsi,%rdi
  8010ba:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	call   *%rax
  8010c6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8010c9:	48 89 de             	mov    %rbx,%rsi
  8010cc:	4c 89 f7             	mov    %r14,%rdi
  8010cf:	48 b8 d7 0d 80 00 00 	movabs $0x800dd7,%rax
  8010d6:	00 00 00 
  8010d9:	ff d0                	call   *%rax
  8010db:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8010de:	48 39 c3             	cmp    %rax,%rbx
  8010e1:	74 36                	je     801119 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8010e3:	48 89 d8             	mov    %rbx,%rax
  8010e6:	4c 29 e8             	sub    %r13,%rax
  8010e9:	49 39 c4             	cmp    %rax,%r12
  8010ec:	73 31                	jae    80111f <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8010ee:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8010f3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8010f7:	4c 89 fe             	mov    %r15,%rsi
  8010fa:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  801101:	00 00 00 
  801104:	ff d0                	call   *%rax
    return dstlen + srclen;
  801106:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80110a:	48 83 c4 08          	add    $0x8,%rsp
  80110e:	5b                   	pop    %rbx
  80110f:	41 5c                	pop    %r12
  801111:	41 5d                	pop    %r13
  801113:	41 5e                	pop    %r14
  801115:	41 5f                	pop    %r15
  801117:	5d                   	pop    %rbp
  801118:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801119:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80111d:	eb eb                	jmp    80110a <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80111f:	48 83 eb 01          	sub    $0x1,%rbx
  801123:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801127:	48 89 da             	mov    %rbx,%rdx
  80112a:	4c 89 fe             	mov    %r15,%rsi
  80112d:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  801134:	00 00 00 
  801137:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801139:	49 01 de             	add    %rbx,%r14
  80113c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801141:	eb c3                	jmp    801106 <strlcat+0x6d>

0000000000801143 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801143:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801147:	48 85 d2             	test   %rdx,%rdx
  80114a:	74 2d                	je     801179 <memcmp+0x36>
  80114c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801151:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801155:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80115a:	44 38 c1             	cmp    %r8b,%cl
  80115d:	75 0f                	jne    80116e <memcmp+0x2b>
    while (n-- > 0) {
  80115f:	48 83 c0 01          	add    $0x1,%rax
  801163:	48 39 c2             	cmp    %rax,%rdx
  801166:	75 e9                	jne    801151 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
  80116d:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80116e:	0f b6 c1             	movzbl %cl,%eax
  801171:	45 0f b6 c0          	movzbl %r8b,%r8d
  801175:	44 29 c0             	sub    %r8d,%eax
  801178:	c3                   	ret
    return 0;
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117e:	c3                   	ret

000000000080117f <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80117f:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801183:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801187:	48 39 c7             	cmp    %rax,%rdi
  80118a:	73 0f                	jae    80119b <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80118c:	40 38 37             	cmp    %sil,(%rdi)
  80118f:	74 0e                	je     80119f <memfind+0x20>
    for (; src < end; src++) {
  801191:	48 83 c7 01          	add    $0x1,%rdi
  801195:	48 39 f8             	cmp    %rdi,%rax
  801198:	75 f2                	jne    80118c <memfind+0xd>
  80119a:	c3                   	ret
  80119b:	48 89 f8             	mov    %rdi,%rax
  80119e:	c3                   	ret
  80119f:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8011a2:	c3                   	ret

00000000008011a3 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8011a3:	f3 0f 1e fa          	endbr64
  8011a7:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8011aa:	0f b6 37             	movzbl (%rdi),%esi
  8011ad:	40 80 fe 20          	cmp    $0x20,%sil
  8011b1:	74 06                	je     8011b9 <strtol+0x16>
  8011b3:	40 80 fe 09          	cmp    $0x9,%sil
  8011b7:	75 13                	jne    8011cc <strtol+0x29>
  8011b9:	48 83 c7 01          	add    $0x1,%rdi
  8011bd:	0f b6 37             	movzbl (%rdi),%esi
  8011c0:	40 80 fe 20          	cmp    $0x20,%sil
  8011c4:	74 f3                	je     8011b9 <strtol+0x16>
  8011c6:	40 80 fe 09          	cmp    $0x9,%sil
  8011ca:	74 ed                	je     8011b9 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8011cc:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8011cf:	83 e0 fd             	and    $0xfffffffd,%eax
  8011d2:	3c 01                	cmp    $0x1,%al
  8011d4:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011d8:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8011de:	75 0f                	jne    8011ef <strtol+0x4c>
  8011e0:	80 3f 30             	cmpb   $0x30,(%rdi)
  8011e3:	74 14                	je     8011f9 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8011e5:	85 d2                	test   %edx,%edx
  8011e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011ec:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8011ef:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8011f4:	4c 63 ca             	movslq %edx,%r9
  8011f7:	eb 36                	jmp    80122f <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011f9:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8011fd:	74 0f                	je     80120e <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8011ff:	85 d2                	test   %edx,%edx
  801201:	75 ec                	jne    8011ef <strtol+0x4c>
        s++;
  801203:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801207:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80120c:	eb e1                	jmp    8011ef <strtol+0x4c>
        s += 2;
  80120e:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801212:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801217:	eb d6                	jmp    8011ef <strtol+0x4c>
            dig -= '0';
  801219:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80121c:	44 0f b6 c1          	movzbl %cl,%r8d
  801220:	41 39 d0             	cmp    %edx,%r8d
  801223:	7d 21                	jge    801246 <strtol+0xa3>
        val = val * base + dig;
  801225:	49 0f af c1          	imul   %r9,%rax
  801229:	0f b6 c9             	movzbl %cl,%ecx
  80122c:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80122f:	48 83 c7 01          	add    $0x1,%rdi
  801233:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801237:	80 f9 39             	cmp    $0x39,%cl
  80123a:	76 dd                	jbe    801219 <strtol+0x76>
        else if (dig - 'a' < 27)
  80123c:	80 f9 7b             	cmp    $0x7b,%cl
  80123f:	77 05                	ja     801246 <strtol+0xa3>
            dig -= 'a' - 10;
  801241:	83 e9 57             	sub    $0x57,%ecx
  801244:	eb d6                	jmp    80121c <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801246:	4d 85 d2             	test   %r10,%r10
  801249:	74 03                	je     80124e <strtol+0xab>
  80124b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80124e:	48 89 c2             	mov    %rax,%rdx
  801251:	48 f7 da             	neg    %rdx
  801254:	40 80 fe 2d          	cmp    $0x2d,%sil
  801258:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80125c:	c3                   	ret

000000000080125d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80125d:	f3 0f 1e fa          	endbr64
  801261:	55                   	push   %rbp
  801262:	48 89 e5             	mov    %rsp,%rbp
  801265:	53                   	push   %rbx
  801266:	48 89 fa             	mov    %rdi,%rdx
  801269:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801271:	bb 00 00 00 00       	mov    $0x0,%ebx
  801276:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80127b:	be 00 00 00 00       	mov    $0x0,%esi
  801280:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801286:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801288:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80128c:	c9                   	leave
  80128d:	c3                   	ret

000000000080128e <sys_cgetc>:

int
sys_cgetc(void) {
  80128e:	f3 0f 1e fa          	endbr64
  801292:	55                   	push   %rbp
  801293:	48 89 e5             	mov    %rsp,%rbp
  801296:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801297:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80129c:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b0:	be 00 00 00 00       	mov    $0x0,%esi
  8012b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012bb:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8012bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c1:	c9                   	leave
  8012c2:	c3                   	ret

00000000008012c3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8012c3:	f3 0f 1e fa          	endbr64
  8012c7:	55                   	push   %rbp
  8012c8:	48 89 e5             	mov    %rsp,%rbp
  8012cb:	53                   	push   %rbx
  8012cc:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8012d0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d3:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e7:	be 00 00 00 00       	mov    $0x0,%esi
  8012ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f4:	48 85 c0             	test   %rax,%rax
  8012f7:	7f 06                	jg     8012ff <sys_env_destroy+0x3c>
}
  8012f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012fd:	c9                   	leave
  8012fe:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012ff:	49 89 c0             	mov    %rax,%r8
  801302:	b9 03 00 00 00       	mov    $0x3,%ecx
  801307:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  80130e:	00 00 00 
  801311:	be 26 00 00 00       	mov    $0x26,%esi
  801316:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  80131d:	00 00 00 
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
  801325:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  80132c:	00 00 00 
  80132f:	41 ff d1             	call   *%r9

0000000000801332 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801332:	f3 0f 1e fa          	endbr64
  801336:	55                   	push   %rbp
  801337:	48 89 e5             	mov    %rsp,%rbp
  80133a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80133b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801340:	ba 00 00 00 00       	mov    $0x0,%edx
  801345:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80134a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801354:	be 00 00 00 00       	mov    $0x0,%esi
  801359:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801361:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801365:	c9                   	leave
  801366:	c3                   	ret

0000000000801367 <sys_yield>:

void
sys_yield(void) {
  801367:	f3 0f 1e fa          	endbr64
  80136b:	55                   	push   %rbp
  80136c:	48 89 e5             	mov    %rsp,%rbp
  80136f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801370:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801375:	ba 00 00 00 00       	mov    $0x0,%edx
  80137a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80137f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801384:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801389:	be 00 00 00 00       	mov    $0x0,%esi
  80138e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801394:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801396:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80139a:	c9                   	leave
  80139b:	c3                   	ret

000000000080139c <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80139c:	f3 0f 1e fa          	endbr64
  8013a0:	55                   	push   %rbp
  8013a1:	48 89 e5             	mov    %rsp,%rbp
  8013a4:	53                   	push   %rbx
  8013a5:	48 89 fa             	mov    %rdi,%rdx
  8013a8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013ab:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013b0:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8013b7:	00 00 00 
  8013ba:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013bf:	be 00 00 00 00       	mov    $0x0,%esi
  8013c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ca:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8013cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013d0:	c9                   	leave
  8013d1:	c3                   	ret

00000000008013d2 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8013d2:	f3 0f 1e fa          	endbr64
  8013d6:	55                   	push   %rbp
  8013d7:	48 89 e5             	mov    %rsp,%rbp
  8013da:	53                   	push   %rbx
  8013db:	49 89 f8             	mov    %rdi,%r8
  8013de:	48 89 d3             	mov    %rdx,%rbx
  8013e1:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8013e4:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e9:	4c 89 c2             	mov    %r8,%rdx
  8013ec:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ef:	be 00 00 00 00       	mov    $0x0,%esi
  8013f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013fa:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8013fc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801400:	c9                   	leave
  801401:	c3                   	ret

0000000000801402 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801402:	f3 0f 1e fa          	endbr64
  801406:	55                   	push   %rbp
  801407:	48 89 e5             	mov    %rsp,%rbp
  80140a:	53                   	push   %rbx
  80140b:	48 83 ec 08          	sub    $0x8,%rsp
  80140f:	89 f8                	mov    %edi,%eax
  801411:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801414:	48 63 f9             	movslq %ecx,%rdi
  801417:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80141a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80141f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801422:	be 00 00 00 00       	mov    $0x0,%esi
  801427:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80142f:	48 85 c0             	test   %rax,%rax
  801432:	7f 06                	jg     80143a <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801434:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801438:	c9                   	leave
  801439:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80143a:	49 89 c0             	mov    %rax,%r8
  80143d:	b9 04 00 00 00       	mov    $0x4,%ecx
  801442:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801449:	00 00 00 
  80144c:	be 26 00 00 00       	mov    $0x26,%esi
  801451:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  801458:	00 00 00 
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
  801460:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  801467:	00 00 00 
  80146a:	41 ff d1             	call   *%r9

000000000080146d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80146d:	f3 0f 1e fa          	endbr64
  801471:	55                   	push   %rbp
  801472:	48 89 e5             	mov    %rsp,%rbp
  801475:	53                   	push   %rbx
  801476:	48 83 ec 08          	sub    $0x8,%rsp
  80147a:	89 f8                	mov    %edi,%eax
  80147c:	49 89 f2             	mov    %rsi,%r10
  80147f:	48 89 cf             	mov    %rcx,%rdi
  801482:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801485:	48 63 da             	movslq %edx,%rbx
  801488:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80148b:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801490:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801493:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801496:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801498:	48 85 c0             	test   %rax,%rax
  80149b:	7f 06                	jg     8014a3 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80149d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a1:	c9                   	leave
  8014a2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014a3:	49 89 c0             	mov    %rax,%r8
  8014a6:	b9 05 00 00 00       	mov    $0x5,%ecx
  8014ab:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8014b2:	00 00 00 
  8014b5:	be 26 00 00 00       	mov    $0x26,%esi
  8014ba:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  8014c1:	00 00 00 
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  8014d0:	00 00 00 
  8014d3:	41 ff d1             	call   *%r9

00000000008014d6 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014d6:	f3 0f 1e fa          	endbr64
  8014da:	55                   	push   %rbp
  8014db:	48 89 e5             	mov    %rsp,%rbp
  8014de:	53                   	push   %rbx
  8014df:	48 83 ec 08          	sub    $0x8,%rsp
  8014e3:	49 89 f9             	mov    %rdi,%r9
  8014e6:	89 f0                	mov    %esi,%eax
  8014e8:	48 89 d3             	mov    %rdx,%rbx
  8014eb:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8014ee:	49 63 f0             	movslq %r8d,%rsi
  8014f1:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014f4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014f9:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801502:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801504:	48 85 c0             	test   %rax,%rax
  801507:	7f 06                	jg     80150f <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801509:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150d:	c9                   	leave
  80150e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80150f:	49 89 c0             	mov    %rax,%r8
  801512:	b9 06 00 00 00       	mov    $0x6,%ecx
  801517:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  80151e:	00 00 00 
  801521:	be 26 00 00 00       	mov    $0x26,%esi
  801526:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  80152d:	00 00 00 
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
  801535:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  80153c:	00 00 00 
  80153f:	41 ff d1             	call   *%r9

0000000000801542 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801542:	f3 0f 1e fa          	endbr64
  801546:	55                   	push   %rbp
  801547:	48 89 e5             	mov    %rsp,%rbp
  80154a:	53                   	push   %rbx
  80154b:	48 83 ec 08          	sub    $0x8,%rsp
  80154f:	48 89 f1             	mov    %rsi,%rcx
  801552:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801555:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801558:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80155d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801562:	be 00 00 00 00       	mov    $0x0,%esi
  801567:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80156f:	48 85 c0             	test   %rax,%rax
  801572:	7f 06                	jg     80157a <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801574:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801578:	c9                   	leave
  801579:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80157a:	49 89 c0             	mov    %rax,%r8
  80157d:	b9 07 00 00 00       	mov    $0x7,%ecx
  801582:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801589:	00 00 00 
  80158c:	be 26 00 00 00       	mov    $0x26,%esi
  801591:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  801598:	00 00 00 
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a0:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  8015a7:	00 00 00 
  8015aa:	41 ff d1             	call   *%r9

00000000008015ad <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8015ad:	f3 0f 1e fa          	endbr64
  8015b1:	55                   	push   %rbp
  8015b2:	48 89 e5             	mov    %rsp,%rbp
  8015b5:	53                   	push   %rbx
  8015b6:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8015ba:	48 63 ce             	movslq %esi,%rcx
  8015bd:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015c0:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ca:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015cf:	be 00 00 00 00       	mov    $0x0,%esi
  8015d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015da:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015dc:	48 85 c0             	test   %rax,%rax
  8015df:	7f 06                	jg     8015e7 <sys_env_set_status+0x3a>
}
  8015e1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015e5:	c9                   	leave
  8015e6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015e7:	49 89 c0             	mov    %rax,%r8
  8015ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ef:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8015f6:	00 00 00 
  8015f9:	be 26 00 00 00       	mov    $0x26,%esi
  8015fe:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  801605:	00 00 00 
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
  80160d:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  801614:	00 00 00 
  801617:	41 ff d1             	call   *%r9

000000000080161a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80161a:	f3 0f 1e fa          	endbr64
  80161e:	55                   	push   %rbp
  80161f:	48 89 e5             	mov    %rsp,%rbp
  801622:	53                   	push   %rbx
  801623:	48 83 ec 08          	sub    $0x8,%rsp
  801627:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80162a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80162d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801632:	bb 00 00 00 00       	mov    $0x0,%ebx
  801637:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80163c:	be 00 00 00 00       	mov    $0x0,%esi
  801641:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801647:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801649:	48 85 c0             	test   %rax,%rax
  80164c:	7f 06                	jg     801654 <sys_env_set_trapframe+0x3a>
}
  80164e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801652:	c9                   	leave
  801653:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801654:	49 89 c0             	mov    %rax,%r8
  801657:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80165c:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801663:	00 00 00 
  801666:	be 26 00 00 00       	mov    $0x26,%esi
  80166b:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  801672:	00 00 00 
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  801681:	00 00 00 
  801684:	41 ff d1             	call   *%r9

0000000000801687 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801687:	f3 0f 1e fa          	endbr64
  80168b:	55                   	push   %rbp
  80168c:	48 89 e5             	mov    %rsp,%rbp
  80168f:	53                   	push   %rbx
  801690:	48 83 ec 08          	sub    $0x8,%rsp
  801694:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801697:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80169a:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80169f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016a9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016b4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016b6:	48 85 c0             	test   %rax,%rax
  8016b9:	7f 06                	jg     8016c1 <sys_env_set_pgfault_upcall+0x3a>
}
  8016bb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016bf:	c9                   	leave
  8016c0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c1:	49 89 c0             	mov    %rax,%r8
  8016c4:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8016c9:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8016d0:	00 00 00 
  8016d3:	be 26 00 00 00       	mov    $0x26,%esi
  8016d8:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  8016df:	00 00 00 
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  8016ee:	00 00 00 
  8016f1:	41 ff d1             	call   *%r9

00000000008016f4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8016f4:	f3 0f 1e fa          	endbr64
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	53                   	push   %rbx
  8016fd:	89 f8                	mov    %edi,%eax
  8016ff:	49 89 f1             	mov    %rsi,%r9
  801702:	48 89 d3             	mov    %rdx,%rbx
  801705:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801708:	49 63 f0             	movslq %r8d,%rsi
  80170b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80170e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801713:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801716:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80171c:	cd 30                	int    $0x30
}
  80171e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801722:	c9                   	leave
  801723:	c3                   	ret

0000000000801724 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801724:	f3 0f 1e fa          	endbr64
  801728:	55                   	push   %rbp
  801729:	48 89 e5             	mov    %rsp,%rbp
  80172c:	53                   	push   %rbx
  80172d:	48 83 ec 08          	sub    $0x8,%rsp
  801731:	48 89 fa             	mov    %rdi,%rdx
  801734:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801737:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80173c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801741:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801746:	be 00 00 00 00       	mov    $0x0,%esi
  80174b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801751:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801753:	48 85 c0             	test   %rax,%rax
  801756:	7f 06                	jg     80175e <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801758:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80175c:	c9                   	leave
  80175d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80175e:	49 89 c0             	mov    %rax,%r8
  801761:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801766:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  80176d:	00 00 00 
  801770:	be 26 00 00 00       	mov    $0x26,%esi
  801775:	48 bf 46 42 80 00 00 	movabs $0x804246,%rdi
  80177c:	00 00 00 
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	49 b9 58 03 80 00 00 	movabs $0x800358,%r9
  80178b:	00 00 00 
  80178e:	41 ff d1             	call   *%r9

0000000000801791 <sys_gettime>:

int
sys_gettime(void) {
  801791:	f3 0f 1e fa          	endbr64
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80179a:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80179f:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017b3:	be 00 00 00 00       	mov    $0x0,%esi
  8017b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017be:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8017c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017c4:	c9                   	leave
  8017c5:	c3                   	ret

00000000008017c6 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8017c6:	f3 0f 1e fa          	endbr64
  8017ca:	55                   	push   %rbp
  8017cb:	48 89 e5             	mov    %rsp,%rbp
  8017ce:	41 56                	push   %r14
  8017d0:	41 55                	push   %r13
  8017d2:	41 54                	push   %r12
  8017d4:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8017d5:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8017dc:	00 00 00 
  8017df:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8017e6:	b8 09 00 00 00       	mov    $0x9,%eax
  8017eb:	cd 30                	int    $0x30
  8017ed:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 7f                	js     801873 <fork+0xad>
  8017f4:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8017f6:	0f 84 83 00 00 00    	je     80187f <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8017fc:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801802:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801809:	00 00 00 
  80180c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801811:	89 c2                	mov    %eax,%edx
  801813:	be 00 00 00 00       	mov    $0x0,%esi
  801818:	bf 00 00 00 00       	mov    $0x0,%edi
  80181d:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  801824:	00 00 00 
  801827:	ff d0                	call   *%rax
  801829:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80182c:	85 c0                	test   %eax,%eax
  80182e:	0f 88 81 00 00 00    	js     8018b5 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801834:	4d 85 f6             	test   %r14,%r14
  801837:	74 20                	je     801859 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801839:	48 be d8 37 80 00 00 	movabs $0x8037d8,%rsi
  801840:	00 00 00 
  801843:	44 89 e7             	mov    %r12d,%edi
  801846:	48 b8 87 16 80 00 00 	movabs $0x801687,%rax
  80184d:	00 00 00 
  801850:	ff d0                	call   *%rax
  801852:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801855:	85 c0                	test   %eax,%eax
  801857:	78 70                	js     8018c9 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801859:	be 02 00 00 00       	mov    $0x2,%esi
  80185e:	89 df                	mov    %ebx,%edi
  801860:	48 b8 ad 15 80 00 00 	movabs $0x8015ad,%rax
  801867:	00 00 00 
  80186a:	ff d0                	call   *%rax
  80186c:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 6a                	js     8018dd <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801873:	44 89 e0             	mov    %r12d,%eax
  801876:	5b                   	pop    %rbx
  801877:	41 5c                	pop    %r12
  801879:	41 5d                	pop    %r13
  80187b:	41 5e                	pop    %r14
  80187d:	5d                   	pop    %rbp
  80187e:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  80187f:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  801886:	00 00 00 
  801889:	ff d0                	call   *%rax
  80188b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801890:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801894:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801898:	48 c1 e0 04          	shl    $0x4,%rax
  80189c:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8018a3:	00 00 00 
  8018a6:	48 01 d0             	add    %rdx,%rax
  8018a9:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8018b0:	00 00 00 
        return 0;
  8018b3:	eb be                	jmp    801873 <fork+0xad>
        sys_env_destroy(envid);
  8018b5:	44 89 e7             	mov    %r12d,%edi
  8018b8:	48 b8 c3 12 80 00 00 	movabs $0x8012c3,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	call   *%rax
        return res;
  8018c4:	45 89 ec             	mov    %r13d,%r12d
  8018c7:	eb aa                	jmp    801873 <fork+0xad>
            sys_env_destroy(envid);
  8018c9:	44 89 e7             	mov    %r12d,%edi
  8018cc:	48 b8 c3 12 80 00 00 	movabs $0x8012c3,%rax
  8018d3:	00 00 00 
  8018d6:	ff d0                	call   *%rax
            return res;
  8018d8:	45 89 ec             	mov    %r13d,%r12d
  8018db:	eb 96                	jmp    801873 <fork+0xad>
        sys_env_destroy(envid);
  8018dd:	89 df                	mov    %ebx,%edi
  8018df:	48 b8 c3 12 80 00 00 	movabs $0x8012c3,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	call   *%rax
        return res;
  8018eb:	45 89 ec             	mov    %r13d,%r12d
  8018ee:	eb 83                	jmp    801873 <fork+0xad>

00000000008018f0 <sfork>:

envid_t
sfork() {
  8018f0:	f3 0f 1e fa          	endbr64
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8018f8:	48 ba 54 42 80 00 00 	movabs $0x804254,%rdx
  8018ff:	00 00 00 
  801902:	be 37 00 00 00       	mov    $0x37,%esi
  801907:	48 bf 6f 42 80 00 00 	movabs $0x80426f,%rdi
  80190e:	00 00 00 
  801911:	b8 00 00 00 00       	mov    $0x0,%eax
  801916:	48 b9 58 03 80 00 00 	movabs $0x800358,%rcx
  80191d:	00 00 00 
  801920:	ff d1                	call   *%rcx

0000000000801922 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801922:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801926:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80192d:	ff ff ff 
  801930:	48 01 f8             	add    %rdi,%rax
  801933:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801937:	c3                   	ret

0000000000801938 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801938:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80193c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801943:	ff ff ff 
  801946:	48 01 f8             	add    %rdi,%rax
  801949:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80194d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801953:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801957:	c3                   	ret

0000000000801958 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801958:	f3 0f 1e fa          	endbr64
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	41 57                	push   %r15
  801962:	41 56                	push   %r14
  801964:	41 55                	push   %r13
  801966:	41 54                	push   %r12
  801968:	53                   	push   %rbx
  801969:	48 83 ec 08          	sub    $0x8,%rsp
  80196d:	49 89 ff             	mov    %rdi,%r15
  801970:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801975:	49 bd 06 34 80 00 00 	movabs $0x803406,%r13
  80197c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80197f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801985:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801988:	48 89 df             	mov    %rbx,%rdi
  80198b:	41 ff d5             	call   *%r13
  80198e:	83 e0 04             	and    $0x4,%eax
  801991:	74 17                	je     8019aa <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801993:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80199a:	4c 39 f3             	cmp    %r14,%rbx
  80199d:	75 e6                	jne    801985 <fd_alloc+0x2d>
  80199f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8019a5:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8019aa:	4d 89 27             	mov    %r12,(%r15)
}
  8019ad:	48 83 c4 08          	add    $0x8,%rsp
  8019b1:	5b                   	pop    %rbx
  8019b2:	41 5c                	pop    %r12
  8019b4:	41 5d                	pop    %r13
  8019b6:	41 5e                	pop    %r14
  8019b8:	41 5f                	pop    %r15
  8019ba:	5d                   	pop    %rbp
  8019bb:	c3                   	ret

00000000008019bc <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019bc:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019c0:	83 ff 1f             	cmp    $0x1f,%edi
  8019c3:	77 39                	ja     8019fe <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019c5:	55                   	push   %rbp
  8019c6:	48 89 e5             	mov    %rsp,%rbp
  8019c9:	41 54                	push   %r12
  8019cb:	53                   	push   %rbx
  8019cc:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019cf:	48 63 df             	movslq %edi,%rbx
  8019d2:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019d9:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019dd:	48 89 df             	mov    %rbx,%rdi
  8019e0:	48 b8 06 34 80 00 00 	movabs $0x803406,%rax
  8019e7:	00 00 00 
  8019ea:	ff d0                	call   *%rax
  8019ec:	a8 04                	test   $0x4,%al
  8019ee:	74 14                	je     801a04 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8019f0:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f9:	5b                   	pop    %rbx
  8019fa:	41 5c                	pop    %r12
  8019fc:	5d                   	pop    %rbp
  8019fd:	c3                   	ret
        return -E_INVAL;
  8019fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a03:	c3                   	ret
        return -E_INVAL;
  801a04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a09:	eb ee                	jmp    8019f9 <fd_lookup+0x3d>

0000000000801a0b <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a0b:	f3 0f 1e fa          	endbr64
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	41 54                	push   %r12
  801a15:	53                   	push   %rbx
  801a16:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a19:	48 b8 c0 48 80 00 00 	movabs $0x8048c0,%rax
  801a20:	00 00 00 
  801a23:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801a2a:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a2d:	39 3b                	cmp    %edi,(%rbx)
  801a2f:	74 47                	je     801a78 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801a31:	48 83 c0 08          	add    $0x8,%rax
  801a35:	48 8b 18             	mov    (%rax),%rbx
  801a38:	48 85 db             	test   %rbx,%rbx
  801a3b:	75 f0                	jne    801a2d <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a3d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a44:	00 00 00 
  801a47:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a4d:	89 fa                	mov    %edi,%edx
  801a4f:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  801a56:	00 00 00 
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5e:	48 b9 b4 04 80 00 00 	movabs $0x8004b4,%rcx
  801a65:	00 00 00 
  801a68:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801a6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801a6f:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801a73:	5b                   	pop    %rbx
  801a74:	41 5c                	pop    %r12
  801a76:	5d                   	pop    %rbp
  801a77:	c3                   	ret
            return 0;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7d:	eb f0                	jmp    801a6f <dev_lookup+0x64>

0000000000801a7f <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a7f:	f3 0f 1e fa          	endbr64
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
  801a87:	41 55                	push   %r13
  801a89:	41 54                	push   %r12
  801a8b:	53                   	push   %rbx
  801a8c:	48 83 ec 18          	sub    $0x18,%rsp
  801a90:	48 89 fb             	mov    %rdi,%rbx
  801a93:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a96:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a9d:	ff ff ff 
  801aa0:	48 01 df             	add    %rbx,%rdi
  801aa3:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801aa7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aab:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	call   *%rax
  801ab7:	41 89 c5             	mov    %eax,%r13d
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 06                	js     801ac4 <fd_close+0x45>
  801abe:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801ac2:	74 1a                	je     801ade <fd_close+0x5f>
        return (must_exist ? res : 0);
  801ac4:	45 84 e4             	test   %r12b,%r12b
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  801acc:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801ad0:	44 89 e8             	mov    %r13d,%eax
  801ad3:	48 83 c4 18          	add    $0x18,%rsp
  801ad7:	5b                   	pop    %rbx
  801ad8:	41 5c                	pop    %r12
  801ada:	41 5d                	pop    %r13
  801adc:	5d                   	pop    %rbp
  801add:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ade:	8b 3b                	mov    (%rbx),%edi
  801ae0:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ae4:	48 b8 0b 1a 80 00 00 	movabs $0x801a0b,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	call   *%rax
  801af0:	41 89 c5             	mov    %eax,%r13d
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 1b                	js     801b12 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801af7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801afb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801aff:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b05:	48 85 c0             	test   %rax,%rax
  801b08:	74 08                	je     801b12 <fd_close+0x93>
  801b0a:	48 89 df             	mov    %rbx,%rdi
  801b0d:	ff d0                	call   *%rax
  801b0f:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b12:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b17:	48 89 de             	mov    %rbx,%rsi
  801b1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1f:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  801b26:	00 00 00 
  801b29:	ff d0                	call   *%rax
    return res;
  801b2b:	eb a3                	jmp    801ad0 <fd_close+0x51>

0000000000801b2d <close>:

int
close(int fdnum) {
  801b2d:	f3 0f 1e fa          	endbr64
  801b31:	55                   	push   %rbp
  801b32:	48 89 e5             	mov    %rsp,%rbp
  801b35:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b39:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b3d:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	78 15                	js     801b62 <close+0x35>

    return fd_close(fd, 1);
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b56:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	call   *%rax
}
  801b62:	c9                   	leave
  801b63:	c3                   	ret

0000000000801b64 <close_all>:

void
close_all(void) {
  801b64:	f3 0f 1e fa          	endbr64
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	41 54                	push   %r12
  801b6e:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b74:	49 bc 2d 1b 80 00 00 	movabs $0x801b2d,%r12
  801b7b:	00 00 00 
  801b7e:	89 df                	mov    %ebx,%edi
  801b80:	41 ff d4             	call   *%r12
  801b83:	83 c3 01             	add    $0x1,%ebx
  801b86:	83 fb 20             	cmp    $0x20,%ebx
  801b89:	75 f3                	jne    801b7e <close_all+0x1a>
}
  801b8b:	5b                   	pop    %rbx
  801b8c:	41 5c                	pop    %r12
  801b8e:	5d                   	pop    %rbp
  801b8f:	c3                   	ret

0000000000801b90 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b90:	f3 0f 1e fa          	endbr64
  801b94:	55                   	push   %rbp
  801b95:	48 89 e5             	mov    %rsp,%rbp
  801b98:	41 57                	push   %r15
  801b9a:	41 56                	push   %r14
  801b9c:	41 55                	push   %r13
  801b9e:	41 54                	push   %r12
  801ba0:	53                   	push   %rbx
  801ba1:	48 83 ec 18          	sub    $0x18,%rsp
  801ba5:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ba8:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801bac:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	call   *%rax
  801bb8:	89 c3                	mov    %eax,%ebx
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	0f 88 b8 00 00 00    	js     801c7a <dup+0xea>
    close(newfdnum);
  801bc2:	44 89 e7             	mov    %r12d,%edi
  801bc5:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  801bcc:	00 00 00 
  801bcf:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bd1:	4d 63 ec             	movslq %r12d,%r13
  801bd4:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801bdb:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801bdf:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801be3:	4c 89 ff             	mov    %r15,%rdi
  801be6:	49 be 38 19 80 00 00 	movabs $0x801938,%r14
  801bed:	00 00 00 
  801bf0:	41 ff d6             	call   *%r14
  801bf3:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bf6:	4c 89 ef             	mov    %r13,%rdi
  801bf9:	41 ff d6             	call   *%r14
  801bfc:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801bff:	48 89 df             	mov    %rbx,%rdi
  801c02:	48 b8 06 34 80 00 00 	movabs $0x803406,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c0e:	a8 04                	test   $0x4,%al
  801c10:	74 2b                	je     801c3d <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c12:	41 89 c1             	mov    %eax,%r9d
  801c15:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c1b:	4c 89 f1             	mov    %r14,%rcx
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	48 89 de             	mov    %rbx,%rsi
  801c26:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2b:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  801c32:	00 00 00 
  801c35:	ff d0                	call   *%rax
  801c37:	89 c3                	mov    %eax,%ebx
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	78 4e                	js     801c8b <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c3d:	4c 89 ff             	mov    %r15,%rdi
  801c40:	48 b8 06 34 80 00 00 	movabs $0x803406,%rax
  801c47:	00 00 00 
  801c4a:	ff d0                	call   *%rax
  801c4c:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c4f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c55:	4c 89 e9             	mov    %r13,%rcx
  801c58:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5d:	4c 89 fe             	mov    %r15,%rsi
  801c60:	bf 00 00 00 00       	mov    $0x0,%edi
  801c65:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  801c6c:	00 00 00 
  801c6f:	ff d0                	call   *%rax
  801c71:	89 c3                	mov    %eax,%ebx
  801c73:	85 c0                	test   %eax,%eax
  801c75:	78 14                	js     801c8b <dup+0xfb>

    return newfdnum;
  801c77:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c7a:	89 d8                	mov    %ebx,%eax
  801c7c:	48 83 c4 18          	add    $0x18,%rsp
  801c80:	5b                   	pop    %rbx
  801c81:	41 5c                	pop    %r12
  801c83:	41 5d                	pop    %r13
  801c85:	41 5e                	pop    %r14
  801c87:	41 5f                	pop    %r15
  801c89:	5d                   	pop    %rbp
  801c8a:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c8b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c90:	4c 89 ee             	mov    %r13,%rsi
  801c93:	bf 00 00 00 00       	mov    $0x0,%edi
  801c98:	49 bc 42 15 80 00 00 	movabs $0x801542,%r12
  801c9f:	00 00 00 
  801ca2:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ca5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801caa:	4c 89 f6             	mov    %r14,%rsi
  801cad:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb2:	41 ff d4             	call   *%r12
    return res;
  801cb5:	eb c3                	jmp    801c7a <dup+0xea>

0000000000801cb7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801cb7:	f3 0f 1e fa          	endbr64
  801cbb:	55                   	push   %rbp
  801cbc:	48 89 e5             	mov    %rsp,%rbp
  801cbf:	41 56                	push   %r14
  801cc1:	41 55                	push   %r13
  801cc3:	41 54                	push   %r12
  801cc5:	53                   	push   %rbx
  801cc6:	48 83 ec 10          	sub    $0x10,%rsp
  801cca:	89 fb                	mov    %edi,%ebx
  801ccc:	49 89 f4             	mov    %rsi,%r12
  801ccf:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cd2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cd6:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801cdd:	00 00 00 
  801ce0:	ff d0                	call   *%rax
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 4c                	js     801d32 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ce6:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801cea:	41 8b 3e             	mov    (%r14),%edi
  801ced:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cf1:	48 b8 0b 1a 80 00 00 	movabs $0x801a0b,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	call   *%rax
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	78 35                	js     801d36 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d01:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d05:	83 e0 03             	and    $0x3,%eax
  801d08:	83 f8 01             	cmp    $0x1,%eax
  801d0b:	74 2d                	je     801d3a <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d11:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d15:	48 85 c0             	test   %rax,%rax
  801d18:	74 56                	je     801d70 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d1a:	4c 89 ea             	mov    %r13,%rdx
  801d1d:	4c 89 e6             	mov    %r12,%rsi
  801d20:	4c 89 f7             	mov    %r14,%rdi
  801d23:	ff d0                	call   *%rax
}
  801d25:	48 83 c4 10          	add    $0x10,%rsp
  801d29:	5b                   	pop    %rbx
  801d2a:	41 5c                	pop    %r12
  801d2c:	41 5d                	pop    %r13
  801d2e:	41 5e                	pop    %r14
  801d30:	5d                   	pop    %rbp
  801d31:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d32:	48 98                	cltq
  801d34:	eb ef                	jmp    801d25 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d36:	48 98                	cltq
  801d38:	eb eb                	jmp    801d25 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d3a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d41:	00 00 00 
  801d44:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d4a:	89 da                	mov    %ebx,%edx
  801d4c:	48 bf 7a 42 80 00 00 	movabs $0x80427a,%rdi
  801d53:	00 00 00 
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5b:	48 b9 b4 04 80 00 00 	movabs $0x8004b4,%rcx
  801d62:	00 00 00 
  801d65:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d67:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d6e:	eb b5                	jmp    801d25 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d70:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d77:	eb ac                	jmp    801d25 <read+0x6e>

0000000000801d79 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d79:	f3 0f 1e fa          	endbr64
  801d7d:	55                   	push   %rbp
  801d7e:	48 89 e5             	mov    %rsp,%rbp
  801d81:	41 57                	push   %r15
  801d83:	41 56                	push   %r14
  801d85:	41 55                	push   %r13
  801d87:	41 54                	push   %r12
  801d89:	53                   	push   %rbx
  801d8a:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d8e:	48 85 d2             	test   %rdx,%rdx
  801d91:	74 54                	je     801de7 <readn+0x6e>
  801d93:	41 89 fd             	mov    %edi,%r13d
  801d96:	49 89 f6             	mov    %rsi,%r14
  801d99:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801da1:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801da6:	49 bf b7 1c 80 00 00 	movabs $0x801cb7,%r15
  801dad:	00 00 00 
  801db0:	4c 89 e2             	mov    %r12,%rdx
  801db3:	48 29 f2             	sub    %rsi,%rdx
  801db6:	4c 01 f6             	add    %r14,%rsi
  801db9:	44 89 ef             	mov    %r13d,%edi
  801dbc:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 20                	js     801de3 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801dc3:	01 c3                	add    %eax,%ebx
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	74 08                	je     801dd1 <readn+0x58>
  801dc9:	48 63 f3             	movslq %ebx,%rsi
  801dcc:	4c 39 e6             	cmp    %r12,%rsi
  801dcf:	72 df                	jb     801db0 <readn+0x37>
    }
    return res;
  801dd1:	48 63 c3             	movslq %ebx,%rax
}
  801dd4:	48 83 c4 08          	add    $0x8,%rsp
  801dd8:	5b                   	pop    %rbx
  801dd9:	41 5c                	pop    %r12
  801ddb:	41 5d                	pop    %r13
  801ddd:	41 5e                	pop    %r14
  801ddf:	41 5f                	pop    %r15
  801de1:	5d                   	pop    %rbp
  801de2:	c3                   	ret
        if (inc < 0) return inc;
  801de3:	48 98                	cltq
  801de5:	eb ed                	jmp    801dd4 <readn+0x5b>
    int inc = 1, res = 0;
  801de7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dec:	eb e3                	jmp    801dd1 <readn+0x58>

0000000000801dee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801dee:	f3 0f 1e fa          	endbr64
  801df2:	55                   	push   %rbp
  801df3:	48 89 e5             	mov    %rsp,%rbp
  801df6:	41 56                	push   %r14
  801df8:	41 55                	push   %r13
  801dfa:	41 54                	push   %r12
  801dfc:	53                   	push   %rbx
  801dfd:	48 83 ec 10          	sub    $0x10,%rsp
  801e01:	89 fb                	mov    %edi,%ebx
  801e03:	49 89 f4             	mov    %rsi,%r12
  801e06:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e09:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e0d:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	call   *%rax
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 47                	js     801e64 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e1d:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e21:	41 8b 3e             	mov    (%r14),%edi
  801e24:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e28:	48 b8 0b 1a 80 00 00 	movabs $0x801a0b,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	call   *%rax
  801e34:	85 c0                	test   %eax,%eax
  801e36:	78 30                	js     801e68 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e38:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e3d:	74 2d                	je     801e6c <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e43:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e47:	48 85 c0             	test   %rax,%rax
  801e4a:	74 56                	je     801ea2 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801e4c:	4c 89 ea             	mov    %r13,%rdx
  801e4f:	4c 89 e6             	mov    %r12,%rsi
  801e52:	4c 89 f7             	mov    %r14,%rdi
  801e55:	ff d0                	call   *%rax
}
  801e57:	48 83 c4 10          	add    $0x10,%rsp
  801e5b:	5b                   	pop    %rbx
  801e5c:	41 5c                	pop    %r12
  801e5e:	41 5d                	pop    %r13
  801e60:	41 5e                	pop    %r14
  801e62:	5d                   	pop    %rbp
  801e63:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e64:	48 98                	cltq
  801e66:	eb ef                	jmp    801e57 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e68:	48 98                	cltq
  801e6a:	eb eb                	jmp    801e57 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e6c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e73:	00 00 00 
  801e76:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e7c:	89 da                	mov    %ebx,%edx
  801e7e:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  801e85:	00 00 00 
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8d:	48 b9 b4 04 80 00 00 	movabs $0x8004b4,%rcx
  801e94:	00 00 00 
  801e97:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e99:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ea0:	eb b5                	jmp    801e57 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ea2:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ea9:	eb ac                	jmp    801e57 <write+0x69>

0000000000801eab <seek>:

int
seek(int fdnum, off_t offset) {
  801eab:	f3 0f 1e fa          	endbr64
  801eaf:	55                   	push   %rbp
  801eb0:	48 89 e5             	mov    %rsp,%rbp
  801eb3:	53                   	push   %rbx
  801eb4:	48 83 ec 18          	sub    $0x18,%rsp
  801eb8:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eba:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ebe:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	call   *%rax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 0c                	js     801eda <seek+0x2f>

    fd->fd_offset = offset;
  801ece:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed2:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eda:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ede:	c9                   	leave
  801edf:	c3                   	ret

0000000000801ee0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ee0:	f3 0f 1e fa          	endbr64
  801ee4:	55                   	push   %rbp
  801ee5:	48 89 e5             	mov    %rsp,%rbp
  801ee8:	41 55                	push   %r13
  801eea:	41 54                	push   %r12
  801eec:	53                   	push   %rbx
  801eed:	48 83 ec 18          	sub    $0x18,%rsp
  801ef1:	89 fb                	mov    %edi,%ebx
  801ef3:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ef6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801efa:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	call   *%rax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 38                	js     801f42 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f0a:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f0e:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f12:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f16:	48 b8 0b 1a 80 00 00 	movabs $0x801a0b,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	call   *%rax
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 1c                	js     801f42 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f26:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f2b:	74 20                	je     801f4d <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f31:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f35:	48 85 c0             	test   %rax,%rax
  801f38:	74 47                	je     801f81 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f3a:	44 89 e6             	mov    %r12d,%esi
  801f3d:	4c 89 ef             	mov    %r13,%rdi
  801f40:	ff d0                	call   *%rax
}
  801f42:	48 83 c4 18          	add    $0x18,%rsp
  801f46:	5b                   	pop    %rbx
  801f47:	41 5c                	pop    %r12
  801f49:	41 5d                	pop    %r13
  801f4b:	5d                   	pop    %rbp
  801f4c:	c3                   	ret
                thisenv->env_id, fdnum);
  801f4d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f54:	00 00 00 
  801f57:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f5d:	89 da                	mov    %ebx,%edx
  801f5f:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  801f66:	00 00 00 
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	48 b9 b4 04 80 00 00 	movabs $0x8004b4,%rcx
  801f75:	00 00 00 
  801f78:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7f:	eb c1                	jmp    801f42 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f81:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f86:	eb ba                	jmp    801f42 <ftruncate+0x62>

0000000000801f88 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f88:	f3 0f 1e fa          	endbr64
  801f8c:	55                   	push   %rbp
  801f8d:	48 89 e5             	mov    %rsp,%rbp
  801f90:	41 54                	push   %r12
  801f92:	53                   	push   %rbx
  801f93:	48 83 ec 10          	sub    $0x10,%rsp
  801f97:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f9a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f9e:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	call   *%rax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	78 4e                	js     801ffc <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fae:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801fb2:	41 8b 3c 24          	mov    (%r12),%edi
  801fb6:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fba:	48 b8 0b 1a 80 00 00 	movabs $0x801a0b,%rax
  801fc1:	00 00 00 
  801fc4:	ff d0                	call   *%rax
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	78 32                	js     801ffc <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fce:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fd3:	74 30                	je     802005 <fstat+0x7d>

    stat->st_name[0] = 0;
  801fd5:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fd8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801fdf:	00 00 00 
    stat->st_isdir = 0;
  801fe2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fe9:	00 00 00 
    stat->st_dev = dev;
  801fec:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801ff3:	48 89 de             	mov    %rbx,%rsi
  801ff6:	4c 89 e7             	mov    %r12,%rdi
  801ff9:	ff 50 28             	call   *0x28(%rax)
}
  801ffc:	48 83 c4 10          	add    $0x10,%rsp
  802000:	5b                   	pop    %rbx
  802001:	41 5c                	pop    %r12
  802003:	5d                   	pop    %rbp
  802004:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802005:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80200a:	eb f0                	jmp    801ffc <fstat+0x74>

000000000080200c <stat>:

int
stat(const char *path, struct Stat *stat) {
  80200c:	f3 0f 1e fa          	endbr64
  802010:	55                   	push   %rbp
  802011:	48 89 e5             	mov    %rsp,%rbp
  802014:	41 54                	push   %r12
  802016:	53                   	push   %rbx
  802017:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  80201a:	be 00 00 00 00       	mov    $0x0,%esi
  80201f:	48 b8 ed 22 80 00 00 	movabs $0x8022ed,%rax
  802026:	00 00 00 
  802029:	ff d0                	call   *%rax
  80202b:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 25                	js     802056 <stat+0x4a>

    int res = fstat(fd, stat);
  802031:	4c 89 e6             	mov    %r12,%rsi
  802034:	89 c7                	mov    %eax,%edi
  802036:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  80203d:	00 00 00 
  802040:	ff d0                	call   *%rax
  802042:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802045:	89 df                	mov    %ebx,%edi
  802047:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  80204e:	00 00 00 
  802051:	ff d0                	call   *%rax

    return res;
  802053:	44 89 e3             	mov    %r12d,%ebx
}
  802056:	89 d8                	mov    %ebx,%eax
  802058:	5b                   	pop    %rbx
  802059:	41 5c                	pop    %r12
  80205b:	5d                   	pop    %rbp
  80205c:	c3                   	ret

000000000080205d <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80205d:	f3 0f 1e fa          	endbr64
  802061:	55                   	push   %rbp
  802062:	48 89 e5             	mov    %rsp,%rbp
  802065:	41 54                	push   %r12
  802067:	53                   	push   %rbx
  802068:	48 83 ec 10          	sub    $0x10,%rsp
  80206c:	41 89 fc             	mov    %edi,%r12d
  80206f:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802072:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802079:	00 00 00 
  80207c:	83 38 00             	cmpl   $0x0,(%rax)
  80207f:	74 6e                	je     8020ef <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802081:	bf 03 00 00 00       	mov    $0x3,%edi
  802086:	48 b8 b9 39 80 00 00 	movabs $0x8039b9,%rax
  80208d:	00 00 00 
  802090:	ff d0                	call   *%rax
  802092:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802099:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80209b:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8020a1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020a6:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8020ad:	00 00 00 
  8020b0:	44 89 e6             	mov    %r12d,%esi
  8020b3:	89 c7                	mov    %eax,%edi
  8020b5:	48 b8 f7 38 80 00 00 	movabs $0x8038f7,%rax
  8020bc:	00 00 00 
  8020bf:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8020c1:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8020c8:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8020c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020ce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020d2:	48 89 de             	mov    %rbx,%rsi
  8020d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020da:	48 b8 5e 38 80 00 00 	movabs $0x80385e,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	call   *%rax
}
  8020e6:	48 83 c4 10          	add    $0x10,%rsp
  8020ea:	5b                   	pop    %rbx
  8020eb:	41 5c                	pop    %r12
  8020ed:	5d                   	pop    %rbp
  8020ee:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8020f4:	48 b8 b9 39 80 00 00 	movabs $0x8039b9,%rax
  8020fb:	00 00 00 
  8020fe:	ff d0                	call   *%rax
  802100:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802107:	00 00 
  802109:	e9 73 ff ff ff       	jmp    802081 <fsipc+0x24>

000000000080210e <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80210e:	f3 0f 1e fa          	endbr64
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802116:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80211d:	00 00 00 
  802120:	8b 57 0c             	mov    0xc(%rdi),%edx
  802123:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802125:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802128:	be 00 00 00 00       	mov    $0x0,%esi
  80212d:	bf 02 00 00 00       	mov    $0x2,%edi
  802132:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  802139:	00 00 00 
  80213c:	ff d0                	call   *%rax
}
  80213e:	5d                   	pop    %rbp
  80213f:	c3                   	ret

0000000000802140 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802140:	f3 0f 1e fa          	endbr64
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802148:	8b 47 0c             	mov    0xc(%rdi),%eax
  80214b:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802152:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802154:	be 00 00 00 00       	mov    $0x0,%esi
  802159:	bf 06 00 00 00       	mov    $0x6,%edi
  80215e:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  802165:	00 00 00 
  802168:	ff d0                	call   *%rax
}
  80216a:	5d                   	pop    %rbp
  80216b:	c3                   	ret

000000000080216c <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80216c:	f3 0f 1e fa          	endbr64
  802170:	55                   	push   %rbp
  802171:	48 89 e5             	mov    %rsp,%rbp
  802174:	41 54                	push   %r12
  802176:	53                   	push   %rbx
  802177:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80217a:	8b 47 0c             	mov    0xc(%rdi),%eax
  80217d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802184:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802186:	be 00 00 00 00       	mov    $0x0,%esi
  80218b:	bf 05 00 00 00       	mov    $0x5,%edi
  802190:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  802197:	00 00 00 
  80219a:	ff d0                	call   *%rax
    if (res < 0) return res;
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 3d                	js     8021dd <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021a0:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8021a7:	00 00 00 
  8021aa:	4c 89 e6             	mov    %r12,%rsi
  8021ad:	48 89 df             	mov    %rbx,%rdi
  8021b0:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021bc:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8021c3:	00 
  8021c4:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021ca:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8021d1:	00 
  8021d2:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021dd:	5b                   	pop    %rbx
  8021de:	41 5c                	pop    %r12
  8021e0:	5d                   	pop    %rbp
  8021e1:	c3                   	ret

00000000008021e2 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021e2:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8021e6:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8021ed:	77 41                	ja     802230 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021ef:	55                   	push   %rbp
  8021f0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021fa:	00 00 00 
  8021fd:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802200:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802202:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802206:	48 8d 78 10          	lea    0x10(%rax),%rdi
  80220a:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  802211:	00 00 00 
  802214:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802216:	be 00 00 00 00       	mov    $0x0,%esi
  80221b:	bf 04 00 00 00       	mov    $0x4,%edi
  802220:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  802227:	00 00 00 
  80222a:	ff d0                	call   *%rax
  80222c:	48 98                	cltq
}
  80222e:	5d                   	pop    %rbp
  80222f:	c3                   	ret
        return -E_INVAL;
  802230:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802237:	c3                   	ret

0000000000802238 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802238:	f3 0f 1e fa          	endbr64
  80223c:	55                   	push   %rbp
  80223d:	48 89 e5             	mov    %rsp,%rbp
  802240:	41 55                	push   %r13
  802242:	41 54                	push   %r12
  802244:	53                   	push   %rbx
  802245:	48 83 ec 08          	sub    $0x8,%rsp
  802249:	49 89 f4             	mov    %rsi,%r12
  80224c:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80224f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802256:	00 00 00 
  802259:	8b 57 0c             	mov    0xc(%rdi),%edx
  80225c:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80225e:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802262:	be 00 00 00 00       	mov    $0x0,%esi
  802267:	bf 03 00 00 00       	mov    $0x3,%edi
  80226c:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  802273:	00 00 00 
  802276:	ff d0                	call   *%rax
  802278:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80227b:	4d 85 ed             	test   %r13,%r13
  80227e:	78 2a                	js     8022aa <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802280:	4c 89 ea             	mov    %r13,%rdx
  802283:	4c 39 eb             	cmp    %r13,%rbx
  802286:	72 30                	jb     8022b8 <devfile_read+0x80>
  802288:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80228f:	7f 27                	jg     8022b8 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802291:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802298:	00 00 00 
  80229b:	4c 89 e7             	mov    %r12,%rdi
  80229e:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	call   *%rax
}
  8022aa:	4c 89 e8             	mov    %r13,%rax
  8022ad:	48 83 c4 08          	add    $0x8,%rsp
  8022b1:	5b                   	pop    %rbx
  8022b2:	41 5c                	pop    %r12
  8022b4:	41 5d                	pop    %r13
  8022b6:	5d                   	pop    %rbp
  8022b7:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8022b8:	48 b9 b3 42 80 00 00 	movabs $0x8042b3,%rcx
  8022bf:	00 00 00 
  8022c2:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  8022c9:	00 00 00 
  8022cc:	be 7b 00 00 00       	mov    $0x7b,%esi
  8022d1:	48 bf e5 42 80 00 00 	movabs $0x8042e5,%rdi
  8022d8:	00 00 00 
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e0:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  8022e7:	00 00 00 
  8022ea:	41 ff d0             	call   *%r8

00000000008022ed <open>:
open(const char *path, int mode) {
  8022ed:	f3 0f 1e fa          	endbr64
  8022f1:	55                   	push   %rbp
  8022f2:	48 89 e5             	mov    %rsp,%rbp
  8022f5:	41 55                	push   %r13
  8022f7:	41 54                	push   %r12
  8022f9:	53                   	push   %rbx
  8022fa:	48 83 ec 18          	sub    $0x18,%rsp
  8022fe:	49 89 fc             	mov    %rdi,%r12
  802301:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802304:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  80230b:	00 00 00 
  80230e:	ff d0                	call   *%rax
  802310:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802316:	0f 87 8a 00 00 00    	ja     8023a6 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80231c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802320:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  802327:	00 00 00 
  80232a:	ff d0                	call   *%rax
  80232c:	89 c3                	mov    %eax,%ebx
  80232e:	85 c0                	test   %eax,%eax
  802330:	78 50                	js     802382 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802332:	4c 89 e6             	mov    %r12,%rsi
  802335:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80233c:	00 00 00 
  80233f:	48 89 df             	mov    %rbx,%rdi
  802342:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  802349:	00 00 00 
  80234c:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80234e:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802355:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802359:	bf 01 00 00 00       	mov    $0x1,%edi
  80235e:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  802365:	00 00 00 
  802368:	ff d0                	call   *%rax
  80236a:	89 c3                	mov    %eax,%ebx
  80236c:	85 c0                	test   %eax,%eax
  80236e:	78 1f                	js     80238f <open+0xa2>
    return fd2num(fd);
  802370:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802374:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  80237b:	00 00 00 
  80237e:	ff d0                	call   *%rax
  802380:	89 c3                	mov    %eax,%ebx
}
  802382:	89 d8                	mov    %ebx,%eax
  802384:	48 83 c4 18          	add    $0x18,%rsp
  802388:	5b                   	pop    %rbx
  802389:	41 5c                	pop    %r12
  80238b:	41 5d                	pop    %r13
  80238d:	5d                   	pop    %rbp
  80238e:	c3                   	ret
        fd_close(fd, 0);
  80238f:	be 00 00 00 00       	mov    $0x0,%esi
  802394:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802398:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	call   *%rax
        return res;
  8023a4:	eb dc                	jmp    802382 <open+0x95>
        return -E_BAD_PATH;
  8023a6:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023ab:	eb d5                	jmp    802382 <open+0x95>

00000000008023ad <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023ad:	f3 0f 1e fa          	endbr64
  8023b1:	55                   	push   %rbp
  8023b2:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023b5:	be 00 00 00 00       	mov    $0x0,%esi
  8023ba:	bf 08 00 00 00       	mov    $0x8,%edi
  8023bf:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	call   *%rax
}
  8023cb:	5d                   	pop    %rbp
  8023cc:	c3                   	ret

00000000008023cd <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8023cd:	f3 0f 1e fa          	endbr64
  8023d1:	55                   	push   %rbp
  8023d2:	48 89 e5             	mov    %rsp,%rbp
  8023d5:	41 55                	push   %r13
  8023d7:	41 54                	push   %r12
  8023d9:	53                   	push   %rbx
  8023da:	48 83 ec 08          	sub    $0x8,%rsp
  8023de:	48 89 fb             	mov    %rdi,%rbx
  8023e1:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8023e4:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8023e7:	48 b8 06 34 80 00 00 	movabs $0x803406,%rax
  8023ee:	00 00 00 
  8023f1:	ff d0                	call   *%rax
  8023f3:	41 89 c1             	mov    %eax,%r9d
  8023f6:	4d 89 e0             	mov    %r12,%r8
  8023f9:	49 29 d8             	sub    %rbx,%r8
  8023fc:	48 89 d9             	mov    %rbx,%rcx
  8023ff:	44 89 ea             	mov    %r13d,%edx
  802402:	48 89 de             	mov    %rbx,%rsi
  802405:	bf 00 00 00 00       	mov    $0x0,%edi
  80240a:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  802411:	00 00 00 
  802414:	ff d0                	call   *%rax
}
  802416:	48 83 c4 08          	add    $0x8,%rsp
  80241a:	5b                   	pop    %rbx
  80241b:	41 5c                	pop    %r12
  80241d:	41 5d                	pop    %r13
  80241f:	5d                   	pop    %rbp
  802420:	c3                   	ret

0000000000802421 <spawn>:
spawn(const char *prog, const char **argv) {
  802421:	f3 0f 1e fa          	endbr64
  802425:	55                   	push   %rbp
  802426:	48 89 e5             	mov    %rsp,%rbp
  802429:	41 57                	push   %r15
  80242b:	41 56                	push   %r14
  80242d:	41 55                	push   %r13
  80242f:	41 54                	push   %r12
  802431:	53                   	push   %rbx
  802432:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802439:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  80243c:	be 00 00 00 00       	mov    $0x0,%esi
  802441:	48 b8 ed 22 80 00 00 	movabs $0x8022ed,%rax
  802448:	00 00 00 
  80244b:	ff d0                	call   *%rax
  80244d:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  802453:	85 c0                	test   %eax,%eax
  802455:	0f 88 30 06 00 00    	js     802a8b <spawn+0x66a>
  80245b:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  80245d:	ba 00 02 00 00       	mov    $0x200,%edx
  802462:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  802469:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  802470:	00 00 00 
  802473:	ff d0                	call   *%rax
  802475:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  802477:	3d 00 02 00 00       	cmp    $0x200,%eax
  80247c:	0f 85 7d 02 00 00    	jne    8026ff <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  802482:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  802489:	ff ff 00 
  80248c:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802493:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  80249a:	01 01 00 
  80249d:	48 39 d0             	cmp    %rdx,%rax
  8024a0:	0f 85 95 02 00 00    	jne    80273b <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  8024a6:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8024ad:	00 3e 00 
  8024b0:	0f 85 85 02 00 00    	jne    80273b <spawn+0x31a>
  8024b6:	b8 09 00 00 00       	mov    $0x9,%eax
  8024bb:	cd 30                	int    $0x30
  8024bd:	41 89 c6             	mov    %eax,%r14d
  8024c0:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	0f 88 a9 05 00 00    	js     802a73 <spawn+0x652>
    envid_t child = res;
  8024ca:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8024d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024d5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8024d9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8024dd:	48 c1 e0 04          	shl    $0x4,%rax
  8024e1:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8024e8:	00 00 00 
  8024eb:	48 01 c6             	add    %rax,%rsi
  8024ee:	48 8b 06             	mov    (%rsi),%rax
  8024f1:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8024f8:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8024ff:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  802506:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  80250d:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  802514:	48 29 ce             	sub    %rcx,%rsi
  802517:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  80251d:	c1 e9 03             	shr    $0x3,%ecx
  802520:	89 c9                	mov    %ecx,%ecx
  802522:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  802525:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80252c:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  802533:	49 8b 3c 24          	mov    (%r12),%rdi
  802537:	48 85 ff             	test   %rdi,%rdi
  80253a:	0f 84 7f 05 00 00    	je     802abf <spawn+0x69e>
  802540:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  802546:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  80254c:	48 bb b8 0d 80 00 00 	movabs $0x800db8,%rbx
  802553:	00 00 00 
  802556:	ff d3                	call   *%rbx
  802558:	4c 01 f8             	add    %r15,%rax
  80255b:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  80255f:	4c 89 ea             	mov    %r13,%rdx
  802562:	49 83 c5 01          	add    $0x1,%r13
  802566:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  80256b:	48 85 ff             	test   %rdi,%rdi
  80256e:	75 e6                	jne    802556 <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802570:	49 89 d5             	mov    %rdx,%r13
  802573:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80257a:	48 f7 d0             	not    %rax
  80257d:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802584:	49 89 df             	mov    %rbx,%r15
  802587:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80258b:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802592:	89 d0                	mov    %edx,%eax
  802594:	83 c0 01             	add    $0x1,%eax
  802597:	48 98                	cltq
  802599:	48 c1 e0 03          	shl    $0x3,%rax
  80259d:	49 29 c7             	sub    %rax,%r15
  8025a0:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8025a7:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8025ab:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8025b1:	0f 86 ff 04 00 00    	jbe    802ab6 <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8025b7:	b9 06 00 00 00       	mov    $0x6,%ecx
  8025bc:	ba 00 00 01 00       	mov    $0x10000,%edx
  8025c1:	be 00 00 40 00       	mov    $0x400000,%esi
  8025c6:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	call   *%rax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	0f 88 e1 04 00 00    	js     802abb <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8025da:	4c 89 e8             	mov    %r13,%rax
  8025dd:	45 85 ed             	test   %r13d,%r13d
  8025e0:	7e 54                	jle    802636 <spawn+0x215>
  8025e2:	4d 89 fd             	mov    %r15,%r13
  8025e5:	48 98                	cltq
  8025e7:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  8025eb:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8025f2:	00 00 00 
  8025f5:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8025fc:	ff 
  8025fd:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  802601:	49 8b 34 24          	mov    (%r12),%rsi
  802605:	48 89 df             	mov    %rbx,%rdi
  802608:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  80260f:	00 00 00 
  802612:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  802614:	49 8b 3c 24          	mov    (%r12),%rdi
  802618:	48 b8 b8 0d 80 00 00 	movabs $0x800db8,%rax
  80261f:	00 00 00 
  802622:	ff d0                	call   *%rax
  802624:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  802629:	49 83 c5 08          	add    $0x8,%r13
  80262d:	49 83 c4 08          	add    $0x8,%r12
  802631:	4d 39 fd             	cmp    %r15,%r13
  802634:	75 b5                	jne    8025eb <spawn+0x1ca>
    argv_store[argc] = 0;
  802636:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  80263d:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802644:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802645:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  80264c:	0f 85 30 01 00 00    	jne    802782 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802652:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802659:	00 00 00 
  80265c:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  802663:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  80266a:	ff 
  80266b:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  80266f:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802676:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  80267a:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802681:	00 00 00 
  802684:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  80268b:	ff 
  80268c:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802693:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802699:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  80269f:	44 89 f2             	mov    %r14d,%edx
  8026a2:	be 00 00 40 00       	mov    $0x400000,%esi
  8026a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ac:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8026b8:	48 bb 42 15 80 00 00 	movabs $0x801542,%rbx
  8026bf:	00 00 00 
  8026c2:	ba 00 00 01 00       	mov    $0x10000,%edx
  8026c7:	be 00 00 40 00       	mov    $0x400000,%esi
  8026cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d1:	ff d3                	call   *%rbx
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	78 eb                	js     8026c2 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8026d7:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8026de:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8026e5:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8026e6:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8026ed:	00 
  8026ee:	0f 84 68 02 00 00    	je     80295c <spawn+0x53b>
  8026f4:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8026fa:	e9 c5 01 00 00       	jmp    8028c4 <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8026ff:	48 bf a8 44 80 00 00 	movabs $0x8044a8,%rdi
  802706:	00 00 00 
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
  80270e:	48 ba b4 04 80 00 00 	movabs $0x8004b4,%rdx
  802715:	00 00 00 
  802718:	ff d2                	call   *%rdx
        close(fd);
  80271a:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802720:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802727:	00 00 00 
  80272a:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  80272c:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802733:	ff ff ff 
  802736:	e9 50 03 00 00       	jmp    802a8b <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80273b:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802740:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  802746:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  80274d:	00 00 00 
  802750:	b8 00 00 00 00       	mov    $0x0,%eax
  802755:	48 b9 b4 04 80 00 00 	movabs $0x8004b4,%rcx
  80275c:	00 00 00 
  80275f:	ff d1                	call   *%rcx
        close(fd);
  802761:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802767:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  80276e:	00 00 00 
  802771:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802773:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  80277a:	ff ff ff 
  80277d:	e9 09 03 00 00       	jmp    802a8b <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802782:	48 b9 d8 44 80 00 00 	movabs $0x8044d8,%rcx
  802789:	00 00 00 
  80278c:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  802793:	00 00 00 
  802796:	be f0 00 00 00       	mov    $0xf0,%esi
  80279b:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  8027a2:	00 00 00 
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027aa:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  8027b1:	00 00 00 
  8027b4:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  8027b7:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  8027bd:	83 c9 02             	or     $0x2,%ecx
  8027c0:	48 89 da             	mov    %rbx,%rdx
  8027c3:	be 00 00 40 00       	mov    $0x400000,%esi
  8027c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8027cd:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	call   *%rax
        if (res < 0) {
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	0f 88 7e 02 00 00    	js     802a5f <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8027e1:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8027e7:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8027ed:	48 b8 ab 1e 80 00 00 	movabs $0x801eab,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	call   *%rax
        if (res < 0) {
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	0f 88 a2 02 00 00    	js     802aa3 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  802801:	48 89 da             	mov    %rbx,%rdx
  802804:	be 00 00 40 00       	mov    $0x400000,%esi
  802809:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80280f:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  802816:	00 00 00 
  802819:	ff d0                	call   *%rax
        if (res < 0) {
  80281b:	85 c0                	test   %eax,%eax
  80281d:	0f 88 84 02 00 00    	js     802aa7 <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  802823:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  80282a:	49 89 d8             	mov    %rbx,%r8
  80282d:	4c 89 e1             	mov    %r12,%rcx
  802830:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  802836:	be 00 00 40 00       	mov    $0x400000,%esi
  80283b:	bf 00 00 00 00       	mov    $0x0,%edi
  802840:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  802847:	00 00 00 
  80284a:	ff d0                	call   *%rax
        if (res < 0) {
  80284c:	85 c0                	test   %eax,%eax
  80284e:	0f 88 57 02 00 00    	js     802aab <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  802854:	48 89 da             	mov    %rbx,%rdx
  802857:	be 00 00 40 00       	mov    $0x400000,%esi
  80285c:	bf 00 00 00 00       	mov    $0x0,%edi
  802861:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  802868:	00 00 00 
  80286b:	ff d0                	call   *%rax
        if (res < 0) {
  80286d:	85 c0                	test   %eax,%eax
  80286f:	0f 89 ca 00 00 00    	jns    80293f <spawn+0x51e>
  802875:	89 c3                	mov    %eax,%ebx
  802877:	e9 e5 01 00 00       	jmp    802a61 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  80287c:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802882:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  802888:	4c 89 ea             	mov    %r13,%rdx
  80288b:	48 29 da             	sub    %rbx,%rdx
  80288e:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  802892:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  802898:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  80289f:	00 00 00 
  8028a2:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	0f 88 a1 00 00 00    	js     80294d <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8028ac:	49 83 c7 01          	add    $0x1,%r15
  8028b0:	49 83 c6 38          	add    $0x38,%r14
  8028b4:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8028bb:	49 39 c7             	cmp    %rax,%r15
  8028be:	0f 83 98 00 00 00    	jae    80295c <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8028c4:	41 83 3e 01          	cmpl   $0x1,(%r14)
  8028c8:	75 e2                	jne    8028ac <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8028ca:	41 8b 46 04          	mov    0x4(%r14),%eax
  8028ce:	89 c2                	mov    %eax,%edx
  8028d0:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8028d3:	89 d1                	mov    %edx,%ecx
  8028d5:	83 c9 04             	or     $0x4,%ecx
  8028d8:	a8 04                	test   $0x4,%al
  8028da:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8028dd:	83 e0 01             	and    $0x1,%eax
  8028e0:	09 d0                	or     %edx,%eax
  8028e2:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8028e8:	49 8b 46 08          	mov    0x8(%r14),%rax
  8028ec:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  8028f2:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  8028f6:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  8028fa:	4d 8b 66 10          	mov    0x10(%r14),%r12
  8028fe:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  802904:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  80290a:	44 89 e2             	mov    %r12d,%edx
  80290d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802913:	74 14                	je     802929 <spawn+0x508>
        va -= res;
  802915:	48 63 ca             	movslq %edx,%rcx
  802918:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  80291b:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  80291e:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  802921:	29 d0                	sub    %edx,%eax
  802923:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  802929:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802930:	0f 87 79 01 00 00    	ja     802aaf <spawn+0x68e>
    if (filesz != 0) {
  802936:	48 85 db             	test   %rbx,%rbx
  802939:	0f 85 78 fe ff ff    	jne    8027b7 <spawn+0x396>
    if (memsz > filesz) {
  80293f:	4c 39 eb             	cmp    %r13,%rbx
  802942:	0f 83 64 ff ff ff    	jae    8028ac <spawn+0x48b>
  802948:	e9 2f ff ff ff       	jmp    80287c <spawn+0x45b>
        if (res < 0) {
  80294d:	ba 00 00 00 00       	mov    $0x0,%edx
  802952:	0f 4e d0             	cmovle %eax,%edx
  802955:	89 d3                	mov    %edx,%ebx
  802957:	e9 05 01 00 00       	jmp    802a61 <spawn+0x640>
    close(fd);
  80295c:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802962:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802969:	00 00 00 
  80296c:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  80296e:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802975:	48 bf cd 23 80 00 00 	movabs $0x8023cd,%rdi
  80297c:	00 00 00 
  80297f:	48 b8 86 34 80 00 00 	movabs $0x803486,%rax
  802986:	00 00 00 
  802989:	ff d0                	call   *%rax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	78 49                	js     8029d8 <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  80298f:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802996:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80299c:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	call   *%rax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	78 59                	js     802a05 <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8029ac:	be 02 00 00 00       	mov    $0x2,%esi
  8029b1:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8029b7:	48 b8 ad 15 80 00 00 	movabs $0x8015ad,%rax
  8029be:	00 00 00 
  8029c1:	ff d0                	call   *%rax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	78 6b                	js     802a32 <spawn+0x611>
    return child;
  8029c7:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8029cd:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8029d3:	e9 b3 00 00 00       	jmp    802a8b <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8029d8:	89 c1                	mov    %eax,%ecx
  8029da:	48 ba 16 43 80 00 00 	movabs $0x804316,%rdx
  8029e1:	00 00 00 
  8029e4:	be 84 00 00 00       	mov    $0x84,%esi
  8029e9:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  8029f0:	00 00 00 
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  8029ff:	00 00 00 
  802a02:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802a05:	89 c1                	mov    %eax,%ecx
  802a07:	48 ba 2d 43 80 00 00 	movabs $0x80432d,%rdx
  802a0e:	00 00 00 
  802a11:	be 87 00 00 00       	mov    $0x87,%esi
  802a16:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802a1d:	00 00 00 
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
  802a25:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  802a2c:	00 00 00 
  802a2f:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802a32:	89 c1                	mov    %eax,%ecx
  802a34:	48 ba 47 43 80 00 00 	movabs $0x804347,%rdx
  802a3b:	00 00 00 
  802a3e:	be 8a 00 00 00       	mov    $0x8a,%esi
  802a43:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802a4a:	00 00 00 
  802a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a52:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  802a59:	00 00 00 
  802a5c:	41 ff d0             	call   *%r8
  802a5f:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802a61:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802a67:	48 b8 c3 12 80 00 00 	movabs $0x8012c3,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	call   *%rax
    close(fd);
  802a73:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802a79:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	call   *%rax
    return res;
  802a85:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  802a8b:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  802a91:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802a98:	5b                   	pop    %rbx
  802a99:	41 5c                	pop    %r12
  802a9b:	41 5d                	pop    %r13
  802a9d:	41 5e                	pop    %r14
  802a9f:	41 5f                	pop    %r15
  802aa1:	5d                   	pop    %rbp
  802aa2:	c3                   	ret
  802aa3:	89 c3                	mov    %eax,%ebx
  802aa5:	eb ba                	jmp    802a61 <spawn+0x640>
  802aa7:	89 c3                	mov    %eax,%ebx
  802aa9:	eb b6                	jmp    802a61 <spawn+0x640>
  802aab:	89 c3                	mov    %eax,%ebx
  802aad:	eb b2                	jmp    802a61 <spawn+0x640>
        return -E_INVAL;
  802aaf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  802ab4:	eb ab                	jmp    802a61 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802ab6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  802abb:	89 c3                	mov    %eax,%ebx
  802abd:	eb a2                	jmp    802a61 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802abf:	b9 06 00 00 00       	mov    $0x6,%ecx
  802ac4:	ba 00 00 01 00       	mov    $0x10000,%edx
  802ac9:	be 00 00 40 00       	mov    $0x400000,%esi
  802ace:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad3:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802ada:	00 00 00 
  802add:	ff d0                	call   *%rax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	78 d8                	js     802abb <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  802ae3:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802aea:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802aee:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  802af5:	f8 ff 40 00 
  802af9:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802b00:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802b04:	bb 00 00 41 00       	mov    $0x410000,%ebx
  802b09:	e9 28 fb ff ff       	jmp    802636 <spawn+0x215>

0000000000802b0e <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802b0e:	f3 0f 1e fa          	endbr64
  802b12:	55                   	push   %rbp
  802b13:	48 89 e5             	mov    %rsp,%rbp
  802b16:	48 83 ec 50          	sub    $0x50,%rsp
  802b1a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802b1e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b22:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802b26:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802b2a:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802b31:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b35:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b39:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b3d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802b41:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802b46:	eb 15                	jmp    802b5d <spawnl+0x4f>
  802b48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b4c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802b50:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b54:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802b58:	74 1c                	je     802b76 <spawnl+0x68>
  802b5a:	83 c1 01             	add    $0x1,%ecx
  802b5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b60:	83 f8 2f             	cmp    $0x2f,%eax
  802b63:	77 e3                	ja     802b48 <spawnl+0x3a>
  802b65:	89 c2                	mov    %eax,%edx
  802b67:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802b6b:	4c 01 d2             	add    %r10,%rdx
  802b6e:	83 c0 08             	add    $0x8,%eax
  802b71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802b74:	eb de                	jmp    802b54 <spawnl+0x46>
    const char *argv[argc + 2];
  802b76:	8d 41 02             	lea    0x2(%rcx),%eax
  802b79:	48 98                	cltq
  802b7b:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802b82:	00 
  802b83:	49 89 c0             	mov    %rax,%r8
  802b86:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  802b8a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802b90:	48 89 e2             	mov    %rsp,%rdx
  802b93:	48 29 c2             	sub    %rax,%rdx
  802b96:	48 39 d4             	cmp    %rdx,%rsp
  802b99:	74 12                	je     802bad <spawnl+0x9f>
  802b9b:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  802ba2:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  802ba9:	00 00 
  802bab:	eb e9                	jmp    802b96 <spawnl+0x88>
  802bad:	4c 89 c0             	mov    %r8,%rax
  802bb0:	25 ff 0f 00 00       	and    $0xfff,%eax
  802bb5:	48 29 c4             	sub    %rax,%rsp
  802bb8:	48 85 c0             	test   %rax,%rax
  802bbb:	74 06                	je     802bc3 <spawnl+0xb5>
  802bbd:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  802bc3:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  802bc8:	4c 89 c8             	mov    %r9,%rax
  802bcb:	48 c1 e8 03          	shr    $0x3,%rax
  802bcf:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  802bd3:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802bda:	00 
    argv[argc + 1] = NULL;
  802bdb:	8d 41 01             	lea    0x1(%rcx),%eax
  802bde:	48 98                	cltq
  802be0:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  802be7:	00 
    va_start(vl, arg0);
  802be8:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802bef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bf3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802bf7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bfb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802bff:	85 c9                	test   %ecx,%ecx
  802c01:	74 41                	je     802c44 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802c03:	49 89 c0             	mov    %rax,%r8
  802c06:	49 8d 41 08          	lea    0x8(%r9),%rax
  802c0a:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802c0d:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  802c12:	eb 1b                	jmp    802c2f <spawnl+0x121>
  802c14:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802c18:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802c1c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c20:	48 8b 11             	mov    (%rcx),%rdx
  802c23:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802c26:	48 83 c0 08          	add    $0x8,%rax
  802c2a:	48 39 f0             	cmp    %rsi,%rax
  802c2d:	74 15                	je     802c44 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802c2f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c32:	83 fa 2f             	cmp    $0x2f,%edx
  802c35:	77 dd                	ja     802c14 <spawnl+0x106>
  802c37:	89 d1                	mov    %edx,%ecx
  802c39:	4c 01 c1             	add    %r8,%rcx
  802c3c:	83 c2 08             	add    $0x8,%edx
  802c3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c42:	eb dc                	jmp    802c20 <spawnl+0x112>
    return spawn(prog, argv);
  802c44:	4c 89 ce             	mov    %r9,%rsi
  802c47:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802c4e:	00 00 00 
  802c51:	ff d0                	call   *%rax
}
  802c53:	c9                   	leave
  802c54:	c3                   	ret

0000000000802c55 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802c55:	f3 0f 1e fa          	endbr64
  802c59:	55                   	push   %rbp
  802c5a:	48 89 e5             	mov    %rsp,%rbp
  802c5d:	41 54                	push   %r12
  802c5f:	53                   	push   %rbx
  802c60:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802c63:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	call   *%rax
  802c6f:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802c72:	48 be 5e 43 80 00 00 	movabs $0x80435e,%rsi
  802c79:	00 00 00 
  802c7c:	48 89 df             	mov    %rbx,%rdi
  802c7f:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802c8b:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802c90:	41 2b 04 24          	sub    (%r12),%eax
  802c94:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802c9a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802ca1:	00 00 00 
    stat->st_dev = &devpipe;
  802ca4:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802cab:	00 00 00 
  802cae:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	5b                   	pop    %rbx
  802cbb:	41 5c                	pop    %r12
  802cbd:	5d                   	pop    %rbp
  802cbe:	c3                   	ret

0000000000802cbf <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802cbf:	f3 0f 1e fa          	endbr64
  802cc3:	55                   	push   %rbp
  802cc4:	48 89 e5             	mov    %rsp,%rbp
  802cc7:	41 54                	push   %r12
  802cc9:	53                   	push   %rbx
  802cca:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802ccd:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cd2:	48 89 fe             	mov    %rdi,%rsi
  802cd5:	bf 00 00 00 00       	mov    $0x0,%edi
  802cda:	49 bc 42 15 80 00 00 	movabs $0x801542,%r12
  802ce1:	00 00 00 
  802ce4:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802ce7:	48 89 df             	mov    %rbx,%rdi
  802cea:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	call   *%rax
  802cf6:	48 89 c6             	mov    %rax,%rsi
  802cf9:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cfe:	bf 00 00 00 00       	mov    $0x0,%edi
  802d03:	41 ff d4             	call   *%r12
}
  802d06:	5b                   	pop    %rbx
  802d07:	41 5c                	pop    %r12
  802d09:	5d                   	pop    %rbp
  802d0a:	c3                   	ret

0000000000802d0b <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d0b:	f3 0f 1e fa          	endbr64
  802d0f:	55                   	push   %rbp
  802d10:	48 89 e5             	mov    %rsp,%rbp
  802d13:	41 57                	push   %r15
  802d15:	41 56                	push   %r14
  802d17:	41 55                	push   %r13
  802d19:	41 54                	push   %r12
  802d1b:	53                   	push   %rbx
  802d1c:	48 83 ec 18          	sub    $0x18,%rsp
  802d20:	49 89 fc             	mov    %rdi,%r12
  802d23:	49 89 f5             	mov    %rsi,%r13
  802d26:	49 89 d7             	mov    %rdx,%r15
  802d29:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802d2d:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802d39:	4d 85 ff             	test   %r15,%r15
  802d3c:	0f 84 af 00 00 00    	je     802df1 <devpipe_write+0xe6>
  802d42:	48 89 c3             	mov    %rax,%rbx
  802d45:	4c 89 f8             	mov    %r15,%rax
  802d48:	4d 89 ef             	mov    %r13,%r15
  802d4b:	4c 01 e8             	add    %r13,%rax
  802d4e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d52:	49 bd d2 13 80 00 00 	movabs $0x8013d2,%r13
  802d59:	00 00 00 
            sys_yield();
  802d5c:	49 be 67 13 80 00 00 	movabs $0x801367,%r14
  802d63:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d66:	8b 73 04             	mov    0x4(%rbx),%esi
  802d69:	48 63 ce             	movslq %esi,%rcx
  802d6c:	48 63 03             	movslq (%rbx),%rax
  802d6f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802d75:	48 39 c1             	cmp    %rax,%rcx
  802d78:	72 2e                	jb     802da8 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d7f:	48 89 da             	mov    %rbx,%rdx
  802d82:	be 00 10 00 00       	mov    $0x1000,%esi
  802d87:	4c 89 e7             	mov    %r12,%rdi
  802d8a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	74 66                	je     802df7 <devpipe_write+0xec>
            sys_yield();
  802d91:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d94:	8b 73 04             	mov    0x4(%rbx),%esi
  802d97:	48 63 ce             	movslq %esi,%rcx
  802d9a:	48 63 03             	movslq (%rbx),%rax
  802d9d:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802da3:	48 39 c1             	cmp    %rax,%rcx
  802da6:	73 d2                	jae    802d7a <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802da8:	41 0f b6 3f          	movzbl (%r15),%edi
  802dac:	48 89 ca             	mov    %rcx,%rdx
  802daf:	48 c1 ea 03          	shr    $0x3,%rdx
  802db3:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802dba:	08 10 20 
  802dbd:	48 f7 e2             	mul    %rdx
  802dc0:	48 c1 ea 06          	shr    $0x6,%rdx
  802dc4:	48 89 d0             	mov    %rdx,%rax
  802dc7:	48 c1 e0 09          	shl    $0x9,%rax
  802dcb:	48 29 d0             	sub    %rdx,%rax
  802dce:	48 c1 e0 03          	shl    $0x3,%rax
  802dd2:	48 29 c1             	sub    %rax,%rcx
  802dd5:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802dda:	83 c6 01             	add    $0x1,%esi
  802ddd:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802de0:	49 83 c7 01          	add    $0x1,%r15
  802de4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802de8:	49 39 c7             	cmp    %rax,%r15
  802deb:	0f 85 75 ff ff ff    	jne    802d66 <devpipe_write+0x5b>
    return n;
  802df1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802df5:	eb 05                	jmp    802dfc <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dfc:	48 83 c4 18          	add    $0x18,%rsp
  802e00:	5b                   	pop    %rbx
  802e01:	41 5c                	pop    %r12
  802e03:	41 5d                	pop    %r13
  802e05:	41 5e                	pop    %r14
  802e07:	41 5f                	pop    %r15
  802e09:	5d                   	pop    %rbp
  802e0a:	c3                   	ret

0000000000802e0b <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802e0b:	f3 0f 1e fa          	endbr64
  802e0f:	55                   	push   %rbp
  802e10:	48 89 e5             	mov    %rsp,%rbp
  802e13:	41 57                	push   %r15
  802e15:	41 56                	push   %r14
  802e17:	41 55                	push   %r13
  802e19:	41 54                	push   %r12
  802e1b:	53                   	push   %rbx
  802e1c:	48 83 ec 18          	sub    $0x18,%rsp
  802e20:	49 89 fc             	mov    %rdi,%r12
  802e23:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802e27:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e2b:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	call   *%rax
  802e37:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802e3a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e40:	49 bd d2 13 80 00 00 	movabs $0x8013d2,%r13
  802e47:	00 00 00 
            sys_yield();
  802e4a:	49 be 67 13 80 00 00 	movabs $0x801367,%r14
  802e51:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802e54:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802e59:	74 7d                	je     802ed8 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e5b:	8b 03                	mov    (%rbx),%eax
  802e5d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e60:	75 26                	jne    802e88 <devpipe_read+0x7d>
            if (i > 0) return i;
  802e62:	4d 85 ff             	test   %r15,%r15
  802e65:	75 77                	jne    802ede <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e67:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e6c:	48 89 da             	mov    %rbx,%rdx
  802e6f:	be 00 10 00 00       	mov    $0x1000,%esi
  802e74:	4c 89 e7             	mov    %r12,%rdi
  802e77:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 72                	je     802ef0 <devpipe_read+0xe5>
            sys_yield();
  802e7e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e81:	8b 03                	mov    (%rbx),%eax
  802e83:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e86:	74 df                	je     802e67 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e88:	48 63 c8             	movslq %eax,%rcx
  802e8b:	48 89 ca             	mov    %rcx,%rdx
  802e8e:	48 c1 ea 03          	shr    $0x3,%rdx
  802e92:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802e99:	08 10 20 
  802e9c:	48 89 d0             	mov    %rdx,%rax
  802e9f:	48 f7 e6             	mul    %rsi
  802ea2:	48 c1 ea 06          	shr    $0x6,%rdx
  802ea6:	48 89 d0             	mov    %rdx,%rax
  802ea9:	48 c1 e0 09          	shl    $0x9,%rax
  802ead:	48 29 d0             	sub    %rdx,%rax
  802eb0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802eb7:	00 
  802eb8:	48 89 c8             	mov    %rcx,%rax
  802ebb:	48 29 d0             	sub    %rdx,%rax
  802ebe:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802ec3:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802ec7:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802ecb:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ece:	49 83 c7 01          	add    $0x1,%r15
  802ed2:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802ed6:	75 83                	jne    802e5b <devpipe_read+0x50>
    return n;
  802ed8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802edc:	eb 03                	jmp    802ee1 <devpipe_read+0xd6>
            if (i > 0) return i;
  802ede:	4c 89 f8             	mov    %r15,%rax
}
  802ee1:	48 83 c4 18          	add    $0x18,%rsp
  802ee5:	5b                   	pop    %rbx
  802ee6:	41 5c                	pop    %r12
  802ee8:	41 5d                	pop    %r13
  802eea:	41 5e                	pop    %r14
  802eec:	41 5f                	pop    %r15
  802eee:	5d                   	pop    %rbp
  802eef:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef5:	eb ea                	jmp    802ee1 <devpipe_read+0xd6>

0000000000802ef7 <pipe>:
pipe(int pfd[2]) {
  802ef7:	f3 0f 1e fa          	endbr64
  802efb:	55                   	push   %rbp
  802efc:	48 89 e5             	mov    %rsp,%rbp
  802eff:	41 55                	push   %r13
  802f01:	41 54                	push   %r12
  802f03:	53                   	push   %rbx
  802f04:	48 83 ec 18          	sub    $0x18,%rsp
  802f08:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f0b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802f0f:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	call   *%rax
  802f1b:	89 c3                	mov    %eax,%ebx
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	0f 88 a0 01 00 00    	js     8030c5 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802f25:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f2a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f2f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f33:	bf 00 00 00 00       	mov    $0x0,%edi
  802f38:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802f3f:	00 00 00 
  802f42:	ff d0                	call   *%rax
  802f44:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f46:	85 c0                	test   %eax,%eax
  802f48:	0f 88 77 01 00 00    	js     8030c5 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f4e:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802f52:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	call   *%rax
  802f5e:	89 c3                	mov    %eax,%ebx
  802f60:	85 c0                	test   %eax,%eax
  802f62:	0f 88 43 01 00 00    	js     8030ab <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802f68:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f6d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f72:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f76:	bf 00 00 00 00       	mov    $0x0,%edi
  802f7b:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	call   *%rax
  802f87:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	0f 88 1a 01 00 00    	js     8030ab <pipe+0x1b4>
    va = fd2data(fd0);
  802f91:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802f95:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	call   *%rax
  802fa1:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802fa4:	b9 46 00 00 00       	mov    $0x46,%ecx
  802fa9:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fae:	48 89 c6             	mov    %rax,%rsi
  802fb1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb6:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  802fbd:	00 00 00 
  802fc0:	ff d0                	call   *%rax
  802fc2:	89 c3                	mov    %eax,%ebx
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	0f 88 c5 00 00 00    	js     803091 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802fcc:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802fd0:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	call   *%rax
  802fdc:	48 89 c1             	mov    %rax,%rcx
  802fdf:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802fe5:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802feb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff0:	4c 89 ee             	mov    %r13,%rsi
  802ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff8:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  802fff:	00 00 00 
  803002:	ff d0                	call   *%rax
  803004:	89 c3                	mov    %eax,%ebx
  803006:	85 c0                	test   %eax,%eax
  803008:	78 6e                	js     803078 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80300a:	be 00 10 00 00       	mov    $0x1000,%esi
  80300f:	4c 89 ef             	mov    %r13,%rdi
  803012:	48 b8 9c 13 80 00 00 	movabs $0x80139c,%rax
  803019:	00 00 00 
  80301c:	ff d0                	call   *%rax
  80301e:	83 f8 02             	cmp    $0x2,%eax
  803021:	0f 85 ab 00 00 00    	jne    8030d2 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  803027:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  80302e:	00 00 
  803030:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803034:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  803036:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80303a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  803041:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803045:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  803047:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80304b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803052:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803056:	48 bb 22 19 80 00 00 	movabs $0x801922,%rbx
  80305d:	00 00 00 
  803060:	ff d3                	call   *%rbx
  803062:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803066:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80306a:	ff d3                	call   *%rbx
  80306c:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803071:	bb 00 00 00 00       	mov    $0x0,%ebx
  803076:	eb 4d                	jmp    8030c5 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803078:	ba 00 10 00 00       	mov    $0x1000,%edx
  80307d:	4c 89 ee             	mov    %r13,%rsi
  803080:	bf 00 00 00 00       	mov    $0x0,%edi
  803085:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  80308c:	00 00 00 
  80308f:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803091:	ba 00 10 00 00       	mov    $0x1000,%edx
  803096:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80309a:	bf 00 00 00 00       	mov    $0x0,%edi
  80309f:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8030ab:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030b0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8030b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b9:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	call   *%rax
}
  8030c5:	89 d8                	mov    %ebx,%eax
  8030c7:	48 83 c4 18          	add    $0x18,%rsp
  8030cb:	5b                   	pop    %rbx
  8030cc:	41 5c                	pop    %r12
  8030ce:	41 5d                	pop    %r13
  8030d0:	5d                   	pop    %rbp
  8030d1:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8030d2:	48 b9 08 45 80 00 00 	movabs $0x804508,%rcx
  8030d9:	00 00 00 
  8030dc:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  8030e3:	00 00 00 
  8030e6:	be 2e 00 00 00       	mov    $0x2e,%esi
  8030eb:	48 bf 65 43 80 00 00 	movabs $0x804365,%rdi
  8030f2:	00 00 00 
  8030f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fa:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  803101:	00 00 00 
  803104:	41 ff d0             	call   *%r8

0000000000803107 <pipeisclosed>:
pipeisclosed(int fdnum) {
  803107:	f3 0f 1e fa          	endbr64
  80310b:	55                   	push   %rbp
  80310c:	48 89 e5             	mov    %rsp,%rbp
  80310f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803113:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803117:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  80311e:	00 00 00 
  803121:	ff d0                	call   *%rax
    if (res < 0) return res;
  803123:	85 c0                	test   %eax,%eax
  803125:	78 35                	js     80315c <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  803127:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80312b:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  803132:	00 00 00 
  803135:	ff d0                	call   *%rax
  803137:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80313a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80313f:	be 00 10 00 00       	mov    $0x1000,%esi
  803144:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803148:	48 b8 d2 13 80 00 00 	movabs $0x8013d2,%rax
  80314f:	00 00 00 
  803152:	ff d0                	call   *%rax
  803154:	85 c0                	test   %eax,%eax
  803156:	0f 94 c0             	sete   %al
  803159:	0f b6 c0             	movzbl %al,%eax
}
  80315c:	c9                   	leave
  80315d:	c3                   	ret

000000000080315e <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  80315e:	f3 0f 1e fa          	endbr64
  803162:	55                   	push   %rbp
  803163:	48 89 e5             	mov    %rsp,%rbp
  803166:	41 55                	push   %r13
  803168:	41 54                	push   %r12
  80316a:	53                   	push   %rbx
  80316b:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  80316f:	85 ff                	test   %edi,%edi
  803171:	74 7d                	je     8031f0 <wait+0x92>
  803173:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803176:	89 f8                	mov    %edi,%eax
  803178:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80317d:	89 fa                	mov    %edi,%edx
  80317f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803185:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  803189:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  80318d:	48 c1 e1 04          	shl    $0x4,%rcx
  803191:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  803198:	00 00 00 
  80319b:	48 01 ca             	add    %rcx,%rdx
  80319e:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  8031a4:	39 d7                	cmp    %edx,%edi
  8031a6:	75 3d                	jne    8031e5 <wait+0x87>
           env->env_status != ENV_FREE) {
  8031a8:	48 98                	cltq
  8031aa:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031ae:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8031b2:	48 c1 e0 04          	shl    $0x4,%rax
  8031b6:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  8031bd:	00 00 00 
  8031c0:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  8031c3:	49 bd 67 13 80 00 00 	movabs $0x801367,%r13
  8031ca:	00 00 00 
           env->env_status != ENV_FREE) {
  8031cd:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 0e                	je     8031e5 <wait+0x87>
        sys_yield();
  8031d7:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  8031da:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  8031e0:	44 39 e0             	cmp    %r12d,%eax
  8031e3:	74 e8                	je     8031cd <wait+0x6f>
    }
}
  8031e5:	48 83 c4 08          	add    $0x8,%rsp
  8031e9:	5b                   	pop    %rbx
  8031ea:	41 5c                	pop    %r12
  8031ec:	41 5d                	pop    %r13
  8031ee:	5d                   	pop    %rbp
  8031ef:	c3                   	ret
    assert(envid != 0);
  8031f0:	48 b9 75 43 80 00 00 	movabs $0x804375,%rcx
  8031f7:	00 00 00 
  8031fa:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  803201:	00 00 00 
  803204:	be 06 00 00 00       	mov    $0x6,%esi
  803209:	48 bf 80 43 80 00 00 	movabs $0x804380,%rdi
  803210:	00 00 00 
  803213:	b8 00 00 00 00       	mov    $0x0,%eax
  803218:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  80321f:	00 00 00 
  803222:	41 ff d0             	call   *%r8

0000000000803225 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  803225:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803229:	48 89 f8             	mov    %rdi,%rax
  80322c:	48 c1 e8 27          	shr    $0x27,%rax
  803230:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803237:	7f 00 00 
  80323a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80323e:	f6 c2 01             	test   $0x1,%dl
  803241:	74 6d                	je     8032b0 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803243:	48 89 f8             	mov    %rdi,%rax
  803246:	48 c1 e8 1e          	shr    $0x1e,%rax
  80324a:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803251:	7f 00 00 
  803254:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803258:	f6 c2 01             	test   $0x1,%dl
  80325b:	74 62                	je     8032bf <get_uvpt_entry+0x9a>
  80325d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803264:	7f 00 00 
  803267:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80326b:	f6 c2 80             	test   $0x80,%dl
  80326e:	75 4f                	jne    8032bf <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803270:	48 89 f8             	mov    %rdi,%rax
  803273:	48 c1 e8 15          	shr    $0x15,%rax
  803277:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80327e:	7f 00 00 
  803281:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803285:	f6 c2 01             	test   $0x1,%dl
  803288:	74 44                	je     8032ce <get_uvpt_entry+0xa9>
  80328a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803291:	7f 00 00 
  803294:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803298:	f6 c2 80             	test   $0x80,%dl
  80329b:	75 31                	jne    8032ce <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80329d:	48 c1 ef 0c          	shr    $0xc,%rdi
  8032a1:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8032a8:	7f 00 00 
  8032ab:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8032af:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8032b0:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8032b7:	7f 00 00 
  8032ba:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032be:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8032bf:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8032c6:	7f 00 00 
  8032c9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032cd:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8032ce:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8032d5:	7f 00 00 
  8032d8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032dc:	c3                   	ret

00000000008032dd <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8032dd:	f3 0f 1e fa          	endbr64
  8032e1:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8032e4:	48 89 f9             	mov    %rdi,%rcx
  8032e7:	48 c1 e9 27          	shr    $0x27,%rcx
  8032eb:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8032f2:	7f 00 00 
  8032f5:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8032f9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803300:	f6 c1 01             	test   $0x1,%cl
  803303:	0f 84 b2 00 00 00    	je     8033bb <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803309:	48 89 f9             	mov    %rdi,%rcx
  80330c:	48 c1 e9 1e          	shr    $0x1e,%rcx
  803310:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803317:	7f 00 00 
  80331a:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80331e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803325:	40 f6 c6 01          	test   $0x1,%sil
  803329:	0f 84 8c 00 00 00    	je     8033bb <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80332f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803336:	7f 00 00 
  803339:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80333d:	a8 80                	test   $0x80,%al
  80333f:	75 7b                	jne    8033bc <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  803341:	48 89 f9             	mov    %rdi,%rcx
  803344:	48 c1 e9 15          	shr    $0x15,%rcx
  803348:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80334f:	7f 00 00 
  803352:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803356:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80335d:	40 f6 c6 01          	test   $0x1,%sil
  803361:	74 58                	je     8033bb <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  803363:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80336a:	7f 00 00 
  80336d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803371:	a8 80                	test   $0x80,%al
  803373:	75 6c                	jne    8033e1 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  803375:	48 89 f9             	mov    %rdi,%rcx
  803378:	48 c1 e9 0c          	shr    $0xc,%rcx
  80337c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803383:	7f 00 00 
  803386:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80338a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  803391:	40 f6 c6 01          	test   $0x1,%sil
  803395:	74 24                	je     8033bb <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  803397:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80339e:	7f 00 00 
  8033a1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033a5:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033ac:	ff ff 7f 
  8033af:	48 21 c8             	and    %rcx,%rax
  8033b2:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8033b8:	48 09 d0             	or     %rdx,%rax
}
  8033bb:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8033bc:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8033c3:	7f 00 00 
  8033c6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033ca:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033d1:	ff ff 7f 
  8033d4:	48 21 c8             	and    %rcx,%rax
  8033d7:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8033dd:	48 01 d0             	add    %rdx,%rax
  8033e0:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8033e1:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8033e8:	7f 00 00 
  8033eb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033ef:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033f6:	ff ff 7f 
  8033f9:	48 21 c8             	and    %rcx,%rax
  8033fc:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  803402:	48 01 d0             	add    %rdx,%rax
  803405:	c3                   	ret

0000000000803406 <get_prot>:

int
get_prot(void *va) {
  803406:	f3 0f 1e fa          	endbr64
  80340a:	55                   	push   %rbp
  80340b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80340e:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  803415:	00 00 00 
  803418:	ff d0                	call   *%rax
  80341a:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80341d:	83 e0 01             	and    $0x1,%eax
  803420:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803423:	89 d1                	mov    %edx,%ecx
  803425:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  80342b:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80342d:	89 c1                	mov    %eax,%ecx
  80342f:	83 c9 02             	or     $0x2,%ecx
  803432:	f6 c2 02             	test   $0x2,%dl
  803435:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803438:	89 c1                	mov    %eax,%ecx
  80343a:	83 c9 01             	or     $0x1,%ecx
  80343d:	48 85 d2             	test   %rdx,%rdx
  803440:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803443:	89 c1                	mov    %eax,%ecx
  803445:	83 c9 40             	or     $0x40,%ecx
  803448:	f6 c6 04             	test   $0x4,%dh
  80344b:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80344e:	5d                   	pop    %rbp
  80344f:	c3                   	ret

0000000000803450 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803450:	f3 0f 1e fa          	endbr64
  803454:	55                   	push   %rbp
  803455:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803458:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  80345f:	00 00 00 
  803462:	ff d0                	call   *%rax
    return pte & PTE_D;
  803464:	48 c1 e8 06          	shr    $0x6,%rax
  803468:	83 e0 01             	and    $0x1,%eax
}
  80346b:	5d                   	pop    %rbp
  80346c:	c3                   	ret

000000000080346d <is_page_present>:

bool
is_page_present(void *va) {
  80346d:	f3 0f 1e fa          	endbr64
  803471:	55                   	push   %rbp
  803472:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803475:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	call   *%rax
  803481:	83 e0 01             	and    $0x1,%eax
}
  803484:	5d                   	pop    %rbp
  803485:	c3                   	ret

0000000000803486 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803486:	f3 0f 1e fa          	endbr64
  80348a:	55                   	push   %rbp
  80348b:	48 89 e5             	mov    %rsp,%rbp
  80348e:	41 57                	push   %r15
  803490:	41 56                	push   %r14
  803492:	41 55                	push   %r13
  803494:	41 54                	push   %r12
  803496:	53                   	push   %rbx
  803497:	48 83 ec 18          	sub    $0x18,%rsp
  80349b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80349f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8034a3:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8034a8:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8034af:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8034b2:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8034b9:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8034bc:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8034c3:	00 00 00 
  8034c6:	eb 73                	jmp    80353b <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8034c8:	48 89 d8             	mov    %rbx,%rax
  8034cb:	48 c1 e8 15          	shr    $0x15,%rax
  8034cf:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8034d6:	7f 00 00 
  8034d9:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8034dd:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8034e3:	f6 c2 01             	test   $0x1,%dl
  8034e6:	74 4b                	je     803533 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8034e8:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8034ec:	f6 c2 80             	test   $0x80,%dl
  8034ef:	74 11                	je     803502 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8034f1:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8034f5:	f6 c4 04             	test   $0x4,%ah
  8034f8:	74 39                	je     803533 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8034fa:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  803500:	eb 20                	jmp    803522 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803502:	48 89 da             	mov    %rbx,%rdx
  803505:	48 c1 ea 0c          	shr    $0xc,%rdx
  803509:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803510:	7f 00 00 
  803513:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  803517:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80351d:	f6 c4 04             	test   $0x4,%ah
  803520:	74 11                	je     803533 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  803522:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  803526:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80352a:	48 89 df             	mov    %rbx,%rdi
  80352d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803531:	ff d0                	call   *%rax
    next:
        va += size;
  803533:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  803536:	49 39 df             	cmp    %rbx,%r15
  803539:	72 3e                	jb     803579 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80353b:	49 8b 06             	mov    (%r14),%rax
  80353e:	a8 01                	test   $0x1,%al
  803540:	74 37                	je     803579 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803542:	48 89 d8             	mov    %rbx,%rax
  803545:	48 c1 e8 1e          	shr    $0x1e,%rax
  803549:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80354e:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803554:	f6 c2 01             	test   $0x1,%dl
  803557:	74 da                	je     803533 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  803559:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80355e:	f6 c2 80             	test   $0x80,%dl
  803561:	0f 84 61 ff ff ff    	je     8034c8 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  803567:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80356c:	f6 c4 04             	test   $0x4,%ah
  80356f:	74 c2                	je     803533 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803571:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  803577:	eb a9                	jmp    803522 <foreach_shared_region+0x9c>
    }
    return res;
}
  803579:	b8 00 00 00 00       	mov    $0x0,%eax
  80357e:	48 83 c4 18          	add    $0x18,%rsp
  803582:	5b                   	pop    %rbx
  803583:	41 5c                	pop    %r12
  803585:	41 5d                	pop    %r13
  803587:	41 5e                	pop    %r14
  803589:	41 5f                	pop    %r15
  80358b:	5d                   	pop    %rbp
  80358c:	c3                   	ret

000000000080358d <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80358d:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  803591:	b8 00 00 00 00       	mov    $0x0,%eax
  803596:	c3                   	ret

0000000000803597 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  803597:	f3 0f 1e fa          	endbr64
  80359b:	55                   	push   %rbp
  80359c:	48 89 e5             	mov    %rsp,%rbp
  80359f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8035a2:	48 be 8b 43 80 00 00 	movabs $0x80438b,%rsi
  8035a9:	00 00 00 
  8035ac:	48 b8 fd 0d 80 00 00 	movabs $0x800dfd,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	call   *%rax
    return 0;
}
  8035b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035bd:	5d                   	pop    %rbp
  8035be:	c3                   	ret

00000000008035bf <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8035bf:	f3 0f 1e fa          	endbr64
  8035c3:	55                   	push   %rbp
  8035c4:	48 89 e5             	mov    %rsp,%rbp
  8035c7:	41 57                	push   %r15
  8035c9:	41 56                	push   %r14
  8035cb:	41 55                	push   %r13
  8035cd:	41 54                	push   %r12
  8035cf:	53                   	push   %rbx
  8035d0:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8035d7:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8035de:	48 85 d2             	test   %rdx,%rdx
  8035e1:	74 7a                	je     80365d <devcons_write+0x9e>
  8035e3:	49 89 d6             	mov    %rdx,%r14
  8035e6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8035ec:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8035f1:	49 bf 18 10 80 00 00 	movabs $0x801018,%r15
  8035f8:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8035fb:	4c 89 f3             	mov    %r14,%rbx
  8035fe:	48 29 f3             	sub    %rsi,%rbx
  803601:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803606:	48 39 c3             	cmp    %rax,%rbx
  803609:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80360d:	4c 63 eb             	movslq %ebx,%r13
  803610:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  803617:	48 01 c6             	add    %rax,%rsi
  80361a:	4c 89 ea             	mov    %r13,%rdx
  80361d:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803624:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  803627:	4c 89 ee             	mov    %r13,%rsi
  80362a:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803631:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  803638:	00 00 00 
  80363b:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80363d:	41 01 dc             	add    %ebx,%r12d
  803640:	49 63 f4             	movslq %r12d,%rsi
  803643:	4c 39 f6             	cmp    %r14,%rsi
  803646:	72 b3                	jb     8035fb <devcons_write+0x3c>
    return res;
  803648:	49 63 c4             	movslq %r12d,%rax
}
  80364b:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  803652:	5b                   	pop    %rbx
  803653:	41 5c                	pop    %r12
  803655:	41 5d                	pop    %r13
  803657:	41 5e                	pop    %r14
  803659:	41 5f                	pop    %r15
  80365b:	5d                   	pop    %rbp
  80365c:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  80365d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803663:	eb e3                	jmp    803648 <devcons_write+0x89>

0000000000803665 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803665:	f3 0f 1e fa          	endbr64
  803669:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80366c:	ba 00 00 00 00       	mov    $0x0,%edx
  803671:	48 85 c0             	test   %rax,%rax
  803674:	74 55                	je     8036cb <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803676:	55                   	push   %rbp
  803677:	48 89 e5             	mov    %rsp,%rbp
  80367a:	41 55                	push   %r13
  80367c:	41 54                	push   %r12
  80367e:	53                   	push   %rbx
  80367f:	48 83 ec 08          	sub    $0x8,%rsp
  803683:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  803686:	48 bb 8e 12 80 00 00 	movabs $0x80128e,%rbx
  80368d:	00 00 00 
  803690:	49 bc 67 13 80 00 00 	movabs $0x801367,%r12
  803697:	00 00 00 
  80369a:	eb 03                	jmp    80369f <devcons_read+0x3a>
  80369c:	41 ff d4             	call   *%r12
  80369f:	ff d3                	call   *%rbx
  8036a1:	85 c0                	test   %eax,%eax
  8036a3:	74 f7                	je     80369c <devcons_read+0x37>
    if (c < 0) return c;
  8036a5:	48 63 d0             	movslq %eax,%rdx
  8036a8:	78 13                	js     8036bd <devcons_read+0x58>
    if (c == 0x04) return 0;
  8036aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8036af:	83 f8 04             	cmp    $0x4,%eax
  8036b2:	74 09                	je     8036bd <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8036b4:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8036b8:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8036bd:	48 89 d0             	mov    %rdx,%rax
  8036c0:	48 83 c4 08          	add    $0x8,%rsp
  8036c4:	5b                   	pop    %rbx
  8036c5:	41 5c                	pop    %r12
  8036c7:	41 5d                	pop    %r13
  8036c9:	5d                   	pop    %rbp
  8036ca:	c3                   	ret
  8036cb:	48 89 d0             	mov    %rdx,%rax
  8036ce:	c3                   	ret

00000000008036cf <cputchar>:
cputchar(int ch) {
  8036cf:	f3 0f 1e fa          	endbr64
  8036d3:	55                   	push   %rbp
  8036d4:	48 89 e5             	mov    %rsp,%rbp
  8036d7:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8036db:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8036df:	be 01 00 00 00       	mov    $0x1,%esi
  8036e4:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8036e8:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	call   *%rax
}
  8036f4:	c9                   	leave
  8036f5:	c3                   	ret

00000000008036f6 <getchar>:
getchar(void) {
  8036f6:	f3 0f 1e fa          	endbr64
  8036fa:	55                   	push   %rbp
  8036fb:	48 89 e5             	mov    %rsp,%rbp
  8036fe:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803702:	ba 01 00 00 00       	mov    $0x1,%edx
  803707:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80370b:	bf 00 00 00 00       	mov    $0x0,%edi
  803710:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  803717:	00 00 00 
  80371a:	ff d0                	call   *%rax
  80371c:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80371e:	85 c0                	test   %eax,%eax
  803720:	78 06                	js     803728 <getchar+0x32>
  803722:	74 08                	je     80372c <getchar+0x36>
  803724:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803728:	89 d0                	mov    %edx,%eax
  80372a:	c9                   	leave
  80372b:	c3                   	ret
    return res < 0 ? res : res ? c :
  80372c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803731:	eb f5                	jmp    803728 <getchar+0x32>

0000000000803733 <iscons>:
iscons(int fdnum) {
  803733:	f3 0f 1e fa          	endbr64
  803737:	55                   	push   %rbp
  803738:	48 89 e5             	mov    %rsp,%rbp
  80373b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80373f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803743:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  80374a:	00 00 00 
  80374d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80374f:	85 c0                	test   %eax,%eax
  803751:	78 18                	js     80376b <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  803753:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803757:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  80375e:	00 00 00 
  803761:	8b 00                	mov    (%rax),%eax
  803763:	39 02                	cmp    %eax,(%rdx)
  803765:	0f 94 c0             	sete   %al
  803768:	0f b6 c0             	movzbl %al,%eax
}
  80376b:	c9                   	leave
  80376c:	c3                   	ret

000000000080376d <opencons>:
opencons(void) {
  80376d:	f3 0f 1e fa          	endbr64
  803771:	55                   	push   %rbp
  803772:	48 89 e5             	mov    %rsp,%rbp
  803775:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  803779:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80377d:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  803784:	00 00 00 
  803787:	ff d0                	call   *%rax
  803789:	85 c0                	test   %eax,%eax
  80378b:	78 49                	js     8037d6 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80378d:	b9 46 00 00 00       	mov    $0x46,%ecx
  803792:	ba 00 10 00 00       	mov    $0x1000,%edx
  803797:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80379b:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a0:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  8037a7:	00 00 00 
  8037aa:	ff d0                	call   *%rax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	78 26                	js     8037d6 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8037b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037b4:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  8037bb:	00 00 
  8037bd:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8037bf:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8037c3:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8037ca:	48 b8 22 19 80 00 00 	movabs $0x801922,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	call   *%rax
}
  8037d6:	c9                   	leave
  8037d7:	c3                   	ret

00000000008037d8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  8037d8:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  8037db:	48 b8 17 3a 80 00 00 	movabs $0x803a17,%rax
  8037e2:	00 00 00 
    call *%rax
  8037e5:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8037e7:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8037ea:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8037f1:	00 
    movq UTRAP_RSP(%rsp), %rsp
  8037f2:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8037f9:	00 
    pushq %rbx
  8037fa:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8037fb:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  803802:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  803805:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  803809:	4c 8b 3c 24          	mov    (%rsp),%r15
  80380d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803812:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803817:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80381c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803821:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803826:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80382b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803830:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803835:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80383a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80383f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803844:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803849:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80384e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803853:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  803857:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80385b:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80385c:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80385d:	c3                   	ret

000000000080385e <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80385e:	f3 0f 1e fa          	endbr64
  803862:	55                   	push   %rbp
  803863:	48 89 e5             	mov    %rsp,%rbp
  803866:	41 54                	push   %r12
  803868:	53                   	push   %rbx
  803869:	48 89 fb             	mov    %rdi,%rbx
  80386c:	48 89 f7             	mov    %rsi,%rdi
  80386f:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803872:	48 85 f6             	test   %rsi,%rsi
  803875:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80387c:	00 00 00 
  80387f:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803883:	be 00 10 00 00       	mov    $0x1000,%esi
  803888:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  80388f:	00 00 00 
  803892:	ff d0                	call   *%rax
    if (res < 0) {
  803894:	85 c0                	test   %eax,%eax
  803896:	78 45                	js     8038dd <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803898:	48 85 db             	test   %rbx,%rbx
  80389b:	74 12                	je     8038af <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80389d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8038a4:	00 00 00 
  8038a7:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8038ad:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  8038af:	4d 85 e4             	test   %r12,%r12
  8038b2:	74 14                	je     8038c8 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8038b4:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8038bb:	00 00 00 
  8038be:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8038c4:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8038c8:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8038cf:	00 00 00 
  8038d2:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8038d8:	5b                   	pop    %rbx
  8038d9:	41 5c                	pop    %r12
  8038db:	5d                   	pop    %rbp
  8038dc:	c3                   	ret
        if (from_env_store != NULL) {
  8038dd:	48 85 db             	test   %rbx,%rbx
  8038e0:	74 06                	je     8038e8 <ipc_recv+0x8a>
            *from_env_store = 0;
  8038e2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8038e8:	4d 85 e4             	test   %r12,%r12
  8038eb:	74 eb                	je     8038d8 <ipc_recv+0x7a>
            *perm_store = 0;
  8038ed:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8038f4:	00 
  8038f5:	eb e1                	jmp    8038d8 <ipc_recv+0x7a>

00000000008038f7 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8038f7:	f3 0f 1e fa          	endbr64
  8038fb:	55                   	push   %rbp
  8038fc:	48 89 e5             	mov    %rsp,%rbp
  8038ff:	41 57                	push   %r15
  803901:	41 56                	push   %r14
  803903:	41 55                	push   %r13
  803905:	41 54                	push   %r12
  803907:	53                   	push   %rbx
  803908:	48 83 ec 18          	sub    $0x18,%rsp
  80390c:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  80390f:	48 89 d3             	mov    %rdx,%rbx
  803912:	49 89 cc             	mov    %rcx,%r12
  803915:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803918:	48 85 d2             	test   %rdx,%rdx
  80391b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803922:	00 00 00 
  803925:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803929:	89 f0                	mov    %esi,%eax
  80392b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80392f:	48 89 da             	mov    %rbx,%rdx
  803932:	48 89 c6             	mov    %rax,%rsi
  803935:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	call   *%rax
    while (res < 0) {
  803941:	85 c0                	test   %eax,%eax
  803943:	79 65                	jns    8039aa <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803945:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803948:	75 33                	jne    80397d <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80394a:	49 bf 67 13 80 00 00 	movabs $0x801367,%r15
  803951:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803954:	49 be f4 16 80 00 00 	movabs $0x8016f4,%r14
  80395b:	00 00 00 
        sys_yield();
  80395e:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803961:	45 89 e8             	mov    %r13d,%r8d
  803964:	4c 89 e1             	mov    %r12,%rcx
  803967:	48 89 da             	mov    %rbx,%rdx
  80396a:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80396e:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803971:	41 ff d6             	call   *%r14
    while (res < 0) {
  803974:	85 c0                	test   %eax,%eax
  803976:	79 32                	jns    8039aa <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803978:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80397b:	74 e1                	je     80395e <ipc_send+0x67>
            panic("Error: %i\n", res);
  80397d:	89 c1                	mov    %eax,%ecx
  80397f:	48 ba 97 43 80 00 00 	movabs $0x804397,%rdx
  803986:	00 00 00 
  803989:	be 42 00 00 00       	mov    $0x42,%esi
  80398e:	48 bf a2 43 80 00 00 	movabs $0x8043a2,%rdi
  803995:	00 00 00 
  803998:	b8 00 00 00 00       	mov    $0x0,%eax
  80399d:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  8039a4:	00 00 00 
  8039a7:	41 ff d0             	call   *%r8
    }
}
  8039aa:	48 83 c4 18          	add    $0x18,%rsp
  8039ae:	5b                   	pop    %rbx
  8039af:	41 5c                	pop    %r12
  8039b1:	41 5d                	pop    %r13
  8039b3:	41 5e                	pop    %r14
  8039b5:	41 5f                	pop    %r15
  8039b7:	5d                   	pop    %rbp
  8039b8:	c3                   	ret

00000000008039b9 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8039b9:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8039bd:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8039c2:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8039c9:	00 00 00 
  8039cc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8039d0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8039d4:	48 c1 e2 04          	shl    $0x4,%rdx
  8039d8:	48 01 ca             	add    %rcx,%rdx
  8039db:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8039e1:	39 fa                	cmp    %edi,%edx
  8039e3:	74 12                	je     8039f7 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8039e5:	48 83 c0 01          	add    $0x1,%rax
  8039e9:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8039ef:	75 db                	jne    8039cc <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8039f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f6:	c3                   	ret
            return envs[i].env_id;
  8039f7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8039fb:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8039ff:	48 c1 e2 04          	shl    $0x4,%rdx
  803a03:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803a0a:	00 00 00 
  803a0d:	48 01 d0             	add    %rdx,%rax
  803a10:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a16:	c3                   	ret

0000000000803a17 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  803a17:	f3 0f 1e fa          	endbr64
  803a1b:	55                   	push   %rbp
  803a1c:	48 89 e5             	mov    %rsp,%rbp
  803a1f:	41 56                	push   %r14
  803a21:	41 55                	push   %r13
  803a23:	41 54                	push   %r12
  803a25:	53                   	push   %rbx
  803a26:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a29:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803a30:	00 00 00 
  803a33:	48 83 38 00          	cmpq   $0x0,(%rax)
  803a37:	74 27                	je     803a60 <_handle_vectored_pagefault+0x49>
  803a39:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803a3e:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  803a45:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a48:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  803a4b:	4c 89 e7             	mov    %r12,%rdi
  803a4e:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803a53:	84 c0                	test   %al,%al
  803a55:	75 45                	jne    803a9c <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a57:	48 83 c3 01          	add    $0x1,%rbx
  803a5b:	49 3b 1e             	cmp    (%r14),%rbx
  803a5e:	72 eb                	jb     803a4b <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803a60:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  803a67:	00 
  803a68:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803a6d:	4d 8b 04 24          	mov    (%r12),%r8
  803a71:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  803a78:	00 00 00 
  803a7b:	be 1d 00 00 00       	mov    $0x1d,%esi
  803a80:	48 bf ac 43 80 00 00 	movabs $0x8043ac,%rdi
  803a87:	00 00 00 
  803a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8f:	49 ba 58 03 80 00 00 	movabs $0x800358,%r10
  803a96:	00 00 00 
  803a99:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803a9c:	5b                   	pop    %rbx
  803a9d:	41 5c                	pop    %r12
  803a9f:	41 5d                	pop    %r13
  803aa1:	41 5e                	pop    %r14
  803aa3:	5d                   	pop    %rbp
  803aa4:	c3                   	ret

0000000000803aa5 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803aa5:	f3 0f 1e fa          	endbr64
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	53                   	push   %rbx
  803aae:	48 83 ec 08          	sub    $0x8,%rsp
  803ab2:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803ab5:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803abc:	00 00 00 
  803abf:	80 38 00             	cmpb   $0x0,(%rax)
  803ac2:	0f 84 84 00 00 00    	je     803b4c <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803ac8:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803acf:	00 00 00 
  803ad2:	48 8b 10             	mov    (%rax),%rdx
  803ad5:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803ada:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803ae1:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803ae4:	48 85 d2             	test   %rdx,%rdx
  803ae7:	74 19                	je     803b02 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803ae9:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803aed:	0f 84 e8 00 00 00    	je     803bdb <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803af3:	48 83 c0 01          	add    $0x1,%rax
  803af7:	48 39 d0             	cmp    %rdx,%rax
  803afa:	75 ed                	jne    803ae9 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803afc:	48 83 fa 08          	cmp    $0x8,%rdx
  803b00:	74 1c                	je     803b1e <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803b02:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803b06:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803b0d:	00 00 00 
  803b10:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803b17:	00 00 00 
  803b1a:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803b1e:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	call   *%rax
  803b2a:	89 c7                	mov    %eax,%edi
  803b2c:	48 be d8 37 80 00 00 	movabs $0x8037d8,%rsi
  803b33:	00 00 00 
  803b36:	48 b8 87 16 80 00 00 	movabs $0x801687,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803b42:	85 c0                	test   %eax,%eax
  803b44:	78 68                	js     803bae <add_pgfault_handler+0x109>
    return res;
}
  803b46:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803b4a:	c9                   	leave
  803b4b:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803b4c:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  803b53:	00 00 00 
  803b56:	ff d0                	call   *%rax
  803b58:	89 c7                	mov    %eax,%edi
  803b5a:	b9 06 00 00 00       	mov    $0x6,%ecx
  803b5f:	ba 00 10 00 00       	mov    $0x1000,%edx
  803b64:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803b6b:	00 00 00 
  803b6e:	48 b8 02 14 80 00 00 	movabs $0x801402,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803b7a:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803b81:	00 00 00 
  803b84:	48 8b 02             	mov    (%rdx),%rax
  803b87:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803b8b:	48 89 0a             	mov    %rcx,(%rdx)
  803b8e:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803b95:	00 00 00 
  803b98:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803b9c:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803ba3:	00 00 00 
  803ba6:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803ba9:	e9 70 ff ff ff       	jmp    803b1e <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803bae:	89 c1                	mov    %eax,%ecx
  803bb0:	48 ba ba 43 80 00 00 	movabs $0x8043ba,%rdx
  803bb7:	00 00 00 
  803bba:	be 3d 00 00 00       	mov    $0x3d,%esi
  803bbf:	48 bf ac 43 80 00 00 	movabs $0x8043ac,%rdi
  803bc6:	00 00 00 
  803bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bce:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  803bd5:	00 00 00 
  803bd8:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  803be0:	e9 61 ff ff ff       	jmp    803b46 <add_pgfault_handler+0xa1>

0000000000803be5 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803be5:	f3 0f 1e fa          	endbr64
  803be9:	55                   	push   %rbp
  803bea:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803bed:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803bf4:	00 00 00 
  803bf7:	80 38 00             	cmpb   $0x0,(%rax)
  803bfa:	74 33                	je     803c2f <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803bfc:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803c03:	00 00 00 
  803c06:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803c0b:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803c12:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803c15:	48 85 c0             	test   %rax,%rax
  803c18:	0f 84 85 00 00 00    	je     803ca3 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  803c1e:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  803c22:	74 40                	je     803c64 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803c24:	48 83 c1 01          	add    $0x1,%rcx
  803c28:	48 39 c1             	cmp    %rax,%rcx
  803c2b:	75 f1                	jne    803c1e <remove_pgfault_handler+0x39>
  803c2d:	eb 74                	jmp    803ca3 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  803c2f:	48 b9 d2 43 80 00 00 	movabs $0x8043d2,%rcx
  803c36:	00 00 00 
  803c39:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  803c40:	00 00 00 
  803c43:	be 43 00 00 00       	mov    $0x43,%esi
  803c48:	48 bf ac 43 80 00 00 	movabs $0x8043ac,%rdi
  803c4f:	00 00 00 
  803c52:	b8 00 00 00 00       	mov    $0x0,%eax
  803c57:	49 b8 58 03 80 00 00 	movabs $0x800358,%r8
  803c5e:	00 00 00 
  803c61:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803c64:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803c6b:	00 
  803c6c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803c70:	48 29 ca             	sub    %rcx,%rdx
  803c73:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803c7a:	00 00 00 
  803c7d:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803c81:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803c86:	48 89 ce             	mov    %rcx,%rsi
  803c89:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	call   *%rax
            _pfhandler_off--;
  803c95:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803c9c:	00 00 00 
  803c9f:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803ca3:	5d                   	pop    %rbp
  803ca4:	c3                   	ret

0000000000803ca5 <__text_end>:
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
