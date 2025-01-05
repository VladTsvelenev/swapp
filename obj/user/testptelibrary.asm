
obj/user/testptelibrary:     file format elf64-x86-64


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
  80001e:	e8 5b 02 00 00       	call   80027e <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <childofspawn>:
    wait(r);
    cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
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
  80003a:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80003f:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  800046:	00 00 00 
  800049:	ff d0                	call   *%rax
    exit();
  80004b:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
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
  800068:	0f 85 49 01 00 00    	jne    8001b7 <umain+0x15e>
    if ((r = sys_alloc_region(0, VA, PAGE_SIZE, PROT_SHARE | PROT_RW)) < 0)
  80006e:	b9 46 00 00 00       	mov    $0x46,%ecx
  800073:	ba 00 10 00 00       	mov    $0x1000,%edx
  800078:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80007d:	bf 00 00 00 00       	mov    $0x0,%edi
  800082:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  800089:	00 00 00 
  80008c:	ff d0                	call   *%rax
  80008e:	85 c0                	test   %eax,%eax
  800090:	0f 88 32 01 00 00    	js     8001c8 <umain+0x16f>
    if ((r = fork()) < 0)
  800096:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	call   *%rax
  8000a2:	89 c3                	mov    %eax,%ebx
  8000a4:	85 c0                	test   %eax,%eax
  8000a6:	0f 88 49 01 00 00    	js     8001f5 <umain+0x19c>
    if (r == 0) {
  8000ac:	0f 84 70 01 00 00    	je     800222 <umain+0x1c9>
    wait(r);
  8000b2:	89 df                	mov    %ebx,%edi
  8000b4:	48 b8 5d 31 80 00 00 	movabs $0x80315d,%rax
  8000bb:	00 00 00 
  8000be:	ff d0                	call   *%rax
    cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000c0:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8000c7:	00 00 00 
  8000ca:	48 8b 30             	mov    (%rax),%rsi
  8000cd:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  8000d2:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	call   *%rax
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	48 be 06 40 80 00 00 	movabs $0x804006,%rsi
  8000e7:	00 00 00 
  8000ea:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8000f1:	00 00 00 
  8000f4:	48 0f 44 f0          	cmove  %rax,%rsi
  8000f8:	48 bf 3e 40 80 00 00 	movabs $0x80403e,%rdi
  8000ff:	00 00 00 
  800102:	b8 00 00 00 00       	mov    $0x0,%eax
  800107:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  80010e:	00 00 00 
  800111:	ff d2                	call   *%rdx
    if ((r = spawnl("/testptelibrary", "testptelibrary", "arg", 0)) < 0)
  800113:	b9 00 00 00 00       	mov    $0x0,%ecx
  800118:	48 ba 59 40 80 00 00 	movabs $0x804059,%rdx
  80011f:	00 00 00 
  800122:	48 be 5e 40 80 00 00 	movabs $0x80405e,%rsi
  800129:	00 00 00 
  80012c:	48 bf 5d 40 80 00 00 	movabs $0x80405d,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	49 b8 0d 2b 80 00 00 	movabs $0x802b0d,%r8
  800142:	00 00 00 
  800145:	41 ff d0             	call   *%r8
  800148:	89 c7                	mov    %eax,%edi
  80014a:	85 c0                	test   %eax,%eax
  80014c:	0f 88 ff 00 00 00    	js     800251 <umain+0x1f8>
    wait(r);
  800152:	48 b8 5d 31 80 00 00 	movabs $0x80315d,%rax
  800159:	00 00 00 
  80015c:	ff d0                	call   *%rax
    cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80015e:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800165:	00 00 00 
  800168:	48 8b 30             	mov    (%rax),%rsi
  80016b:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800170:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  800177:	00 00 00 
  80017a:	ff d0                	call   *%rax
  80017c:	85 c0                	test   %eax,%eax
  80017e:	48 be 06 40 80 00 00 	movabs $0x804006,%rsi
  800185:	00 00 00 
  800188:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80018f:	00 00 00 
  800192:	48 0f 44 f0          	cmove  %rax,%rsi
  800196:	48 bf 77 40 80 00 00 	movabs $0x804077,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  8001ac:	00 00 00 
  8001af:	ff d2                	call   *%rdx
}
  8001b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001b5:	c9                   	leave
  8001b6:	c3                   	ret
        childofspawn();
  8001b7:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001be:	00 00 00 
  8001c1:	ff d0                	call   *%rax
  8001c3:	e9 a6 fe ff ff       	jmp    80006e <umain+0x15>
        panic("sys_page_alloc: %i", r);
  8001c8:	89 c1                	mov    %eax,%ecx
  8001ca:	48 ba 0c 40 80 00 00 	movabs $0x80400c,%rdx
  8001d1:	00 00 00 
  8001d4:	be 11 00 00 00       	mov    $0x11,%esi
  8001d9:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  8001ef:	00 00 00 
  8001f2:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  8001f5:	89 c1                	mov    %eax,%ecx
  8001f7:	48 ba 35 40 80 00 00 	movabs $0x804035,%rdx
  8001fe:	00 00 00 
  800201:	be 15 00 00 00       	mov    $0x15,%esi
  800206:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  80020d:	00 00 00 
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  80021c:	00 00 00 
  80021f:	41 ff d0             	call   *%r8
        strcpy(VA, msg);
  800222:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800229:	00 00 00 
  80022c:	48 8b 30             	mov    (%rax),%rsi
  80022f:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800234:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	call   *%rax
        exit();
  800240:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  800247:	00 00 00 
  80024a:	ff d0                	call   *%rax
  80024c:	e9 61 fe ff ff       	jmp    8000b2 <umain+0x59>
        panic("spawn: %i", r);
  800251:	89 c1                	mov    %eax,%ecx
  800253:	48 ba 6d 40 80 00 00 	movabs $0x80406d,%rdx
  80025a:	00 00 00 
  80025d:	be 1f 00 00 00       	mov    $0x1f,%esi
  800262:	48 bf 1f 40 80 00 00 	movabs $0x80401f,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  800278:	00 00 00 
  80027b:	41 ff d0             	call   *%r8

000000000080027e <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80027e:	f3 0f 1e fa          	endbr64
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
  800286:	41 56                	push   %r14
  800288:	41 55                	push   %r13
  80028a:	41 54                	push   %r12
  80028c:	53                   	push   %rbx
  80028d:	41 89 fd             	mov    %edi,%r13d
  800290:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800293:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80029a:	00 00 00 
  80029d:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8002a4:	00 00 00 
  8002a7:	48 39 c2             	cmp    %rax,%rdx
  8002aa:	73 17                	jae    8002c3 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8002ac:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8002af:	49 89 c4             	mov    %rax,%r12
  8002b2:	48 83 c3 08          	add    $0x8,%rbx
  8002b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002bb:	ff 53 f8             	call   *-0x8(%rbx)
  8002be:	4c 39 e3             	cmp    %r12,%rbx
  8002c1:	72 ef                	jb     8002b2 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8002c3:	48 b8 31 13 80 00 00 	movabs $0x801331,%rax
  8002ca:	00 00 00 
  8002cd:	ff d0                	call   *%rax
  8002cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8002d8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8002dc:	48 c1 e0 04          	shl    $0x4,%rax
  8002e0:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8002e7:	00 00 00 
  8002ea:	48 01 d0             	add    %rdx,%rax
  8002ed:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8002f4:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8002f7:	45 85 ed             	test   %r13d,%r13d
  8002fa:	7e 0d                	jle    800309 <libmain+0x8b>
  8002fc:	49 8b 06             	mov    (%r14),%rax
  8002ff:	48 a3 10 50 80 00 00 	movabs %rax,0x805010
  800306:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800309:	4c 89 f6             	mov    %r14,%rsi
  80030c:	44 89 ef             	mov    %r13d,%edi
  80030f:	48 b8 59 00 80 00 00 	movabs $0x800059,%rax
  800316:	00 00 00 
  800319:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80031b:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  800322:	00 00 00 
  800325:	ff d0                	call   *%rax
#endif
}
  800327:	5b                   	pop    %rbx
  800328:	41 5c                	pop    %r12
  80032a:	41 5d                	pop    %r13
  80032c:	41 5e                	pop    %r14
  80032e:	5d                   	pop    %rbp
  80032f:	c3                   	ret

0000000000800330 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800330:	f3 0f 1e fa          	endbr64
  800334:	55                   	push   %rbp
  800335:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800338:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  80033f:	00 00 00 
  800342:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800344:	bf 00 00 00 00       	mov    $0x0,%edi
  800349:	48 b8 c2 12 80 00 00 	movabs $0x8012c2,%rax
  800350:	00 00 00 
  800353:	ff d0                	call   *%rax
}
  800355:	5d                   	pop    %rbp
  800356:	c3                   	ret

0000000000800357 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800357:	f3 0f 1e fa          	endbr64
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
  80035f:	41 56                	push   %r14
  800361:	41 55                	push   %r13
  800363:	41 54                	push   %r12
  800365:	53                   	push   %rbx
  800366:	48 83 ec 50          	sub    $0x50,%rsp
  80036a:	49 89 fc             	mov    %rdi,%r12
  80036d:	41 89 f5             	mov    %esi,%r13d
  800370:	48 89 d3             	mov    %rdx,%rbx
  800373:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800377:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80037b:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80037f:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800386:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80038e:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800392:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800396:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  80039d:	00 00 00 
  8003a0:	4c 8b 30             	mov    (%rax),%r14
  8003a3:	48 b8 31 13 80 00 00 	movabs $0x801331,%rax
  8003aa:	00 00 00 
  8003ad:	ff d0                	call   *%rax
  8003af:	89 c6                	mov    %eax,%esi
  8003b1:	45 89 e8             	mov    %r13d,%r8d
  8003b4:	4c 89 e1             	mov    %r12,%rcx
  8003b7:	4c 89 f2             	mov    %r14,%rdx
  8003ba:	48 bf f0 43 80 00 00 	movabs $0x8043f0,%rdi
  8003c1:	00 00 00 
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	49 bc b3 04 80 00 00 	movabs $0x8004b3,%r12
  8003d0:	00 00 00 
  8003d3:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8003d6:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8003da:	48 89 df             	mov    %rbx,%rdi
  8003dd:	48 b8 4b 04 80 00 00 	movabs $0x80044b,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	call   *%rax
    cprintf("\n");
  8003e9:	48 bf a1 40 80 00 00 	movabs $0x8040a1,%rdi
  8003f0:	00 00 00 
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8003fb:	cc                   	int3
  8003fc:	eb fd                	jmp    8003fb <_panic+0xa4>

00000000008003fe <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8003fe:	f3 0f 1e fa          	endbr64
  800402:	55                   	push   %rbp
  800403:	48 89 e5             	mov    %rsp,%rbp
  800406:	53                   	push   %rbx
  800407:	48 83 ec 08          	sub    $0x8,%rsp
  80040b:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80040e:	8b 06                	mov    (%rsi),%eax
  800410:	8d 50 01             	lea    0x1(%rax),%edx
  800413:	89 16                	mov    %edx,(%rsi)
  800415:	48 98                	cltq
  800417:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80041c:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800422:	74 0a                	je     80042e <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800424:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800428:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80042c:	c9                   	leave
  80042d:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80042e:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800432:	be ff 00 00 00       	mov    $0xff,%esi
  800437:	48 b8 5c 12 80 00 00 	movabs $0x80125c,%rax
  80043e:	00 00 00 
  800441:	ff d0                	call   *%rax
        state->offset = 0;
  800443:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800449:	eb d9                	jmp    800424 <putch+0x26>

000000000080044b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80044b:	f3 0f 1e fa          	endbr64
  80044f:	55                   	push   %rbp
  800450:	48 89 e5             	mov    %rsp,%rbp
  800453:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80045a:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80045d:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800464:	b9 21 00 00 00       	mov    $0x21,%ecx
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800471:	48 89 f1             	mov    %rsi,%rcx
  800474:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80047b:	48 bf fe 03 80 00 00 	movabs $0x8003fe,%rdi
  800482:	00 00 00 
  800485:	48 b8 13 06 80 00 00 	movabs $0x800613,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800491:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800498:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80049f:	48 b8 5c 12 80 00 00 	movabs $0x80125c,%rax
  8004a6:	00 00 00 
  8004a9:	ff d0                	call   *%rax

    return state.count;
}
  8004ab:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8004b1:	c9                   	leave
  8004b2:	c3                   	ret

00000000008004b3 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8004b3:	f3 0f 1e fa          	endbr64
  8004b7:	55                   	push   %rbp
  8004b8:	48 89 e5             	mov    %rsp,%rbp
  8004bb:	48 83 ec 50          	sub    $0x50,%rsp
  8004bf:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8004c3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8004c7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004cb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004cf:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8004d3:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8004da:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004e2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004e6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8004ea:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8004ee:	48 b8 4b 04 80 00 00 	movabs $0x80044b,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8004fa:	c9                   	leave
  8004fb:	c3                   	ret

00000000008004fc <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8004fc:	f3 0f 1e fa          	endbr64
  800500:	55                   	push   %rbp
  800501:	48 89 e5             	mov    %rsp,%rbp
  800504:	41 57                	push   %r15
  800506:	41 56                	push   %r14
  800508:	41 55                	push   %r13
  80050a:	41 54                	push   %r12
  80050c:	53                   	push   %rbx
  80050d:	48 83 ec 18          	sub    $0x18,%rsp
  800511:	49 89 fc             	mov    %rdi,%r12
  800514:	49 89 f5             	mov    %rsi,%r13
  800517:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80051b:	8b 45 10             	mov    0x10(%rbp),%eax
  80051e:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800521:	41 89 cf             	mov    %ecx,%r15d
  800524:	4c 39 fa             	cmp    %r15,%rdx
  800527:	73 5b                	jae    800584 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800529:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80052d:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800531:	85 db                	test   %ebx,%ebx
  800533:	7e 0e                	jle    800543 <print_num+0x47>
            putch(padc, put_arg);
  800535:	4c 89 ee             	mov    %r13,%rsi
  800538:	44 89 f7             	mov    %r14d,%edi
  80053b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80053e:	83 eb 01             	sub    $0x1,%ebx
  800541:	75 f2                	jne    800535 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800543:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800547:	48 b9 cc 40 80 00 00 	movabs $0x8040cc,%rcx
  80054e:	00 00 00 
  800551:	48 b8 bb 40 80 00 00 	movabs $0x8040bb,%rax
  800558:	00 00 00 
  80055b:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80055f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800563:	ba 00 00 00 00       	mov    $0x0,%edx
  800568:	49 f7 f7             	div    %r15
  80056b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80056f:	4c 89 ee             	mov    %r13,%rsi
  800572:	41 ff d4             	call   *%r12
}
  800575:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800579:	5b                   	pop    %rbx
  80057a:	41 5c                	pop    %r12
  80057c:	41 5d                	pop    %r13
  80057e:	41 5e                	pop    %r14
  800580:	41 5f                	pop    %r15
  800582:	5d                   	pop    %rbp
  800583:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800584:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800588:	ba 00 00 00 00       	mov    $0x0,%edx
  80058d:	49 f7 f7             	div    %r15
  800590:	48 83 ec 08          	sub    $0x8,%rsp
  800594:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800598:	52                   	push   %rdx
  800599:	45 0f be c9          	movsbl %r9b,%r9d
  80059d:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8005a1:	48 89 c2             	mov    %rax,%rdx
  8005a4:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	call   *%rax
  8005b0:	48 83 c4 10          	add    $0x10,%rsp
  8005b4:	eb 8d                	jmp    800543 <print_num+0x47>

00000000008005b6 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8005b6:	f3 0f 1e fa          	endbr64
    state->count++;
  8005ba:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8005be:	48 8b 06             	mov    (%rsi),%rax
  8005c1:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8005c5:	73 0a                	jae    8005d1 <sprintputch+0x1b>
        *state->start++ = ch;
  8005c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8005cb:	48 89 16             	mov    %rdx,(%rsi)
  8005ce:	40 88 38             	mov    %dil,(%rax)
    }
}
  8005d1:	c3                   	ret

00000000008005d2 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8005d2:	f3 0f 1e fa          	endbr64
  8005d6:	55                   	push   %rbp
  8005d7:	48 89 e5             	mov    %rsp,%rbp
  8005da:	48 83 ec 50          	sub    $0x50,%rsp
  8005de:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005e2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005e6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8005ea:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8005f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005f5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005f9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005fd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800601:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800605:	48 b8 13 06 80 00 00 	movabs $0x800613,%rax
  80060c:	00 00 00 
  80060f:	ff d0                	call   *%rax
}
  800611:	c9                   	leave
  800612:	c3                   	ret

0000000000800613 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800613:	f3 0f 1e fa          	endbr64
  800617:	55                   	push   %rbp
  800618:	48 89 e5             	mov    %rsp,%rbp
  80061b:	41 57                	push   %r15
  80061d:	41 56                	push   %r14
  80061f:	41 55                	push   %r13
  800621:	41 54                	push   %r12
  800623:	53                   	push   %rbx
  800624:	48 83 ec 38          	sub    $0x38,%rsp
  800628:	49 89 fe             	mov    %rdi,%r14
  80062b:	49 89 f5             	mov    %rsi,%r13
  80062e:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800631:	48 8b 01             	mov    (%rcx),%rax
  800634:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800638:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80063c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800640:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800644:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800648:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80064c:	0f b6 3b             	movzbl (%rbx),%edi
  80064f:	40 80 ff 25          	cmp    $0x25,%dil
  800653:	74 18                	je     80066d <vprintfmt+0x5a>
            if (!ch) return;
  800655:	40 84 ff             	test   %dil,%dil
  800658:	0f 84 b2 06 00 00    	je     800d10 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80065e:	40 0f b6 ff          	movzbl %dil,%edi
  800662:	4c 89 ee             	mov    %r13,%rsi
  800665:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800668:	4c 89 e3             	mov    %r12,%rbx
  80066b:	eb db                	jmp    800648 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80066d:	be 00 00 00 00       	mov    $0x0,%esi
  800672:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800676:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80067b:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800681:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800688:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80068c:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800691:	41 0f b6 04 24       	movzbl (%r12),%eax
  800696:	88 45 a0             	mov    %al,-0x60(%rbp)
  800699:	83 e8 23             	sub    $0x23,%eax
  80069c:	3c 57                	cmp    $0x57,%al
  80069e:	0f 87 52 06 00 00    	ja     800cf6 <vprintfmt+0x6e3>
  8006a4:	0f b6 c0             	movzbl %al,%eax
  8006a7:	48 b9 60 45 80 00 00 	movabs $0x804560,%rcx
  8006ae:	00 00 00 
  8006b1:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8006b5:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8006b8:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8006bc:	eb ce                	jmp    80068c <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8006be:	49 89 dc             	mov    %rbx,%r12
  8006c1:	be 01 00 00 00       	mov    $0x1,%esi
  8006c6:	eb c4                	jmp    80068c <vprintfmt+0x79>
            padc = ch;
  8006c8:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8006cc:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8006cf:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8006d2:	eb b8                	jmp    80068c <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8006d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d7:	83 f8 2f             	cmp    $0x2f,%eax
  8006da:	77 24                	ja     800700 <vprintfmt+0xed>
  8006dc:	89 c1                	mov    %eax,%ecx
  8006de:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8006e2:	83 c0 08             	add    $0x8,%eax
  8006e5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e8:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8006eb:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8006ee:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006f2:	79 98                	jns    80068c <vprintfmt+0x79>
                width = precision;
  8006f4:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8006f8:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8006fe:	eb 8c                	jmp    80068c <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800700:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800704:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800708:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070c:	eb da                	jmp    8006e8 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80070e:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800713:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800717:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80071d:	3c 39                	cmp    $0x39,%al
  80071f:	77 1c                	ja     80073d <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800721:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800725:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800729:	0f b6 c0             	movzbl %al,%eax
  80072c:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800731:	0f b6 03             	movzbl (%rbx),%eax
  800734:	3c 39                	cmp    $0x39,%al
  800736:	76 e9                	jbe    800721 <vprintfmt+0x10e>
        process_precision:
  800738:	49 89 dc             	mov    %rbx,%r12
  80073b:	eb b1                	jmp    8006ee <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80073d:	49 89 dc             	mov    %rbx,%r12
  800740:	eb ac                	jmp    8006ee <vprintfmt+0xdb>
            width = MAX(0, width);
  800742:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800745:	85 c9                	test   %ecx,%ecx
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	0f 49 c1             	cmovns %ecx,%eax
  80074f:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800752:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800755:	e9 32 ff ff ff       	jmp    80068c <vprintfmt+0x79>
            lflag++;
  80075a:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80075d:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800760:	e9 27 ff ff ff       	jmp    80068c <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800765:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800768:	83 f8 2f             	cmp    $0x2f,%eax
  80076b:	77 19                	ja     800786 <vprintfmt+0x173>
  80076d:	89 c2                	mov    %eax,%edx
  80076f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800773:	83 c0 08             	add    $0x8,%eax
  800776:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800779:	8b 3a                	mov    (%rdx),%edi
  80077b:	4c 89 ee             	mov    %r13,%rsi
  80077e:	41 ff d6             	call   *%r14
            break;
  800781:	e9 c2 fe ff ff       	jmp    800648 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800786:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80078a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80078e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800792:	eb e5                	jmp    800779 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800794:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800797:	83 f8 2f             	cmp    $0x2f,%eax
  80079a:	77 5a                	ja     8007f6 <vprintfmt+0x1e3>
  80079c:	89 c2                	mov    %eax,%edx
  80079e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a2:	83 c0 08             	add    $0x8,%eax
  8007a5:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8007a8:	8b 02                	mov    (%rdx),%eax
  8007aa:	89 c1                	mov    %eax,%ecx
  8007ac:	f7 d9                	neg    %ecx
  8007ae:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8007b1:	83 f9 13             	cmp    $0x13,%ecx
  8007b4:	7f 4e                	jg     800804 <vprintfmt+0x1f1>
  8007b6:	48 63 c1             	movslq %ecx,%rax
  8007b9:	48 ba 20 48 80 00 00 	movabs $0x804820,%rdx
  8007c0:	00 00 00 
  8007c3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8007c7:	48 85 c0             	test   %rax,%rax
  8007ca:	74 38                	je     800804 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8007cc:	48 89 c1             	mov    %rax,%rcx
  8007cf:	48 ba e6 42 80 00 00 	movabs $0x8042e6,%rdx
  8007d6:	00 00 00 
  8007d9:	4c 89 ee             	mov    %r13,%rsi
  8007dc:	4c 89 f7             	mov    %r14,%rdi
  8007df:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e4:	49 b8 d2 05 80 00 00 	movabs $0x8005d2,%r8
  8007eb:	00 00 00 
  8007ee:	41 ff d0             	call   *%r8
  8007f1:	e9 52 fe ff ff       	jmp    800648 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8007f6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800802:	eb a4                	jmp    8007a8 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800804:	48 ba e4 40 80 00 00 	movabs $0x8040e4,%rdx
  80080b:	00 00 00 
  80080e:	4c 89 ee             	mov    %r13,%rsi
  800811:	4c 89 f7             	mov    %r14,%rdi
  800814:	b8 00 00 00 00       	mov    $0x0,%eax
  800819:	49 b8 d2 05 80 00 00 	movabs $0x8005d2,%r8
  800820:	00 00 00 
  800823:	41 ff d0             	call   *%r8
  800826:	e9 1d fe ff ff       	jmp    800648 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80082b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082e:	83 f8 2f             	cmp    $0x2f,%eax
  800831:	77 6c                	ja     80089f <vprintfmt+0x28c>
  800833:	89 c2                	mov    %eax,%edx
  800835:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800839:	83 c0 08             	add    $0x8,%eax
  80083c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80083f:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800842:	48 85 d2             	test   %rdx,%rdx
  800845:	48 b8 dd 40 80 00 00 	movabs $0x8040dd,%rax
  80084c:	00 00 00 
  80084f:	48 0f 45 c2          	cmovne %rdx,%rax
  800853:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800857:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80085b:	7e 06                	jle    800863 <vprintfmt+0x250>
  80085d:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800861:	75 4a                	jne    8008ad <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800863:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800867:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80086b:	0f b6 00             	movzbl (%rax),%eax
  80086e:	84 c0                	test   %al,%al
  800870:	0f 85 9a 00 00 00    	jne    800910 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800876:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800879:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80087d:	85 c0                	test   %eax,%eax
  80087f:	0f 8e c3 fd ff ff    	jle    800648 <vprintfmt+0x35>
  800885:	4c 89 ee             	mov    %r13,%rsi
  800888:	bf 20 00 00 00       	mov    $0x20,%edi
  80088d:	41 ff d6             	call   *%r14
  800890:	41 83 ec 01          	sub    $0x1,%r12d
  800894:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800898:	75 eb                	jne    800885 <vprintfmt+0x272>
  80089a:	e9 a9 fd ff ff       	jmp    800648 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80089f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ab:	eb 92                	jmp    80083f <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8008ad:	49 63 f7             	movslq %r15d,%rsi
  8008b0:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8008b4:	48 b8 d6 0d 80 00 00 	movabs $0x800dd6,%rax
  8008bb:	00 00 00 
  8008be:	ff d0                	call   *%rax
  8008c0:	48 89 c2             	mov    %rax,%rdx
  8008c3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008c6:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8008c8:	8d 70 ff             	lea    -0x1(%rax),%esi
  8008cb:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	7e 91                	jle    800863 <vprintfmt+0x250>
  8008d2:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8008d7:	4c 89 ee             	mov    %r13,%rsi
  8008da:	44 89 e7             	mov    %r12d,%edi
  8008dd:	41 ff d6             	call   *%r14
  8008e0:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8008e4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008e7:	83 f8 ff             	cmp    $0xffffffff,%eax
  8008ea:	75 eb                	jne    8008d7 <vprintfmt+0x2c4>
  8008ec:	e9 72 ff ff ff       	jmp    800863 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8008f1:	0f b6 f8             	movzbl %al,%edi
  8008f4:	4c 89 ee             	mov    %r13,%rsi
  8008f7:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008fa:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8008fe:	49 83 c4 01          	add    $0x1,%r12
  800902:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800908:	84 c0                	test   %al,%al
  80090a:	0f 84 66 ff ff ff    	je     800876 <vprintfmt+0x263>
  800910:	45 85 ff             	test   %r15d,%r15d
  800913:	78 0a                	js     80091f <vprintfmt+0x30c>
  800915:	41 83 ef 01          	sub    $0x1,%r15d
  800919:	0f 88 57 ff ff ff    	js     800876 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80091f:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800923:	74 cc                	je     8008f1 <vprintfmt+0x2de>
  800925:	8d 50 e0             	lea    -0x20(%rax),%edx
  800928:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80092d:	80 fa 5e             	cmp    $0x5e,%dl
  800930:	77 c2                	ja     8008f4 <vprintfmt+0x2e1>
  800932:	eb bd                	jmp    8008f1 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800934:	40 84 f6             	test   %sil,%sil
  800937:	75 26                	jne    80095f <vprintfmt+0x34c>
    switch (lflag) {
  800939:	85 d2                	test   %edx,%edx
  80093b:	74 59                	je     800996 <vprintfmt+0x383>
  80093d:	83 fa 01             	cmp    $0x1,%edx
  800940:	74 7b                	je     8009bd <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800942:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800945:	83 f8 2f             	cmp    $0x2f,%eax
  800948:	0f 87 96 00 00 00    	ja     8009e4 <vprintfmt+0x3d1>
  80094e:	89 c2                	mov    %eax,%edx
  800950:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800954:	83 c0 08             	add    $0x8,%eax
  800957:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095a:	4c 8b 22             	mov    (%rdx),%r12
  80095d:	eb 17                	jmp    800976 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80095f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800962:	83 f8 2f             	cmp    $0x2f,%eax
  800965:	77 21                	ja     800988 <vprintfmt+0x375>
  800967:	89 c2                	mov    %eax,%edx
  800969:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80096d:	83 c0 08             	add    $0x8,%eax
  800970:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800973:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800976:	4d 85 e4             	test   %r12,%r12
  800979:	78 7a                	js     8009f5 <vprintfmt+0x3e2>
            num = i;
  80097b:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80097e:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800983:	e9 50 02 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800988:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800990:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800994:	eb dd                	jmp    800973 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800996:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800999:	83 f8 2f             	cmp    $0x2f,%eax
  80099c:	77 11                	ja     8009af <vprintfmt+0x39c>
  80099e:	89 c2                	mov    %eax,%edx
  8009a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a4:	83 c0 08             	add    $0x8,%eax
  8009a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009aa:	4c 63 22             	movslq (%rdx),%r12
  8009ad:	eb c7                	jmp    800976 <vprintfmt+0x363>
  8009af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009bb:	eb ed                	jmp    8009aa <vprintfmt+0x397>
        return va_arg(*ap, long);
  8009bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c0:	83 f8 2f             	cmp    $0x2f,%eax
  8009c3:	77 11                	ja     8009d6 <vprintfmt+0x3c3>
  8009c5:	89 c2                	mov    %eax,%edx
  8009c7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009cb:	83 c0 08             	add    $0x8,%eax
  8009ce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d1:	4c 8b 22             	mov    (%rdx),%r12
  8009d4:	eb a0                	jmp    800976 <vprintfmt+0x363>
  8009d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009da:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e2:	eb ed                	jmp    8009d1 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8009e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f0:	e9 65 ff ff ff       	jmp    80095a <vprintfmt+0x347>
                putch('-', put_arg);
  8009f5:	4c 89 ee             	mov    %r13,%rsi
  8009f8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009fd:	41 ff d6             	call   *%r14
                i = -i;
  800a00:	49 f7 dc             	neg    %r12
  800a03:	e9 73 ff ff ff       	jmp    80097b <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800a08:	40 84 f6             	test   %sil,%sil
  800a0b:	75 32                	jne    800a3f <vprintfmt+0x42c>
    switch (lflag) {
  800a0d:	85 d2                	test   %edx,%edx
  800a0f:	74 5d                	je     800a6e <vprintfmt+0x45b>
  800a11:	83 fa 01             	cmp    $0x1,%edx
  800a14:	0f 84 82 00 00 00    	je     800a9c <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800a1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1d:	83 f8 2f             	cmp    $0x2f,%eax
  800a20:	0f 87 a5 00 00 00    	ja     800acb <vprintfmt+0x4b8>
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2c:	83 c0 08             	add    $0x8,%eax
  800a2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a32:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a35:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a3a:	e9 99 01 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a42:	83 f8 2f             	cmp    $0x2f,%eax
  800a45:	77 19                	ja     800a60 <vprintfmt+0x44d>
  800a47:	89 c2                	mov    %eax,%edx
  800a49:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4d:	83 c0 08             	add    $0x8,%eax
  800a50:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a53:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a56:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a5b:	e9 78 01 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
  800a60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a64:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6c:	eb e5                	jmp    800a53 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800a6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a71:	83 f8 2f             	cmp    $0x2f,%eax
  800a74:	77 18                	ja     800a8e <vprintfmt+0x47b>
  800a76:	89 c2                	mov    %eax,%edx
  800a78:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7c:	83 c0 08             	add    $0x8,%eax
  800a7f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a82:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800a84:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800a89:	e9 4a 01 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
  800a8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a92:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9a:	eb e6                	jmp    800a82 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800a9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9f:	83 f8 2f             	cmp    $0x2f,%eax
  800aa2:	77 19                	ja     800abd <vprintfmt+0x4aa>
  800aa4:	89 c2                	mov    %eax,%edx
  800aa6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aaa:	83 c0 08             	add    $0x8,%eax
  800aad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab0:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ab3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800ab8:	e9 1b 01 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
  800abd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac9:	eb e5                	jmp    800ab0 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800acb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad7:	e9 56 ff ff ff       	jmp    800a32 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800adc:	40 84 f6             	test   %sil,%sil
  800adf:	75 2e                	jne    800b0f <vprintfmt+0x4fc>
    switch (lflag) {
  800ae1:	85 d2                	test   %edx,%edx
  800ae3:	74 59                	je     800b3e <vprintfmt+0x52b>
  800ae5:	83 fa 01             	cmp    $0x1,%edx
  800ae8:	74 7f                	je     800b69 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800aea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aed:	83 f8 2f             	cmp    $0x2f,%eax
  800af0:	0f 87 9f 00 00 00    	ja     800b95 <vprintfmt+0x582>
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800afc:	83 c0 08             	add    $0x8,%eax
  800aff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b02:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b05:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b0a:	e9 c9 00 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b12:	83 f8 2f             	cmp    $0x2f,%eax
  800b15:	77 19                	ja     800b30 <vprintfmt+0x51d>
  800b17:	89 c2                	mov    %eax,%edx
  800b19:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b1d:	83 c0 08             	add    $0x8,%eax
  800b20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b23:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b26:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b2b:	e9 a8 00 00 00       	jmp    800bd8 <vprintfmt+0x5c5>
  800b30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b34:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b38:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b3c:	eb e5                	jmp    800b23 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800b3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b41:	83 f8 2f             	cmp    $0x2f,%eax
  800b44:	77 15                	ja     800b5b <vprintfmt+0x548>
  800b46:	89 c2                	mov    %eax,%edx
  800b48:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b4c:	83 c0 08             	add    $0x8,%eax
  800b4f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b52:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800b54:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800b59:	eb 7d                	jmp    800bd8 <vprintfmt+0x5c5>
  800b5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b63:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b67:	eb e9                	jmp    800b52 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800b69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6c:	83 f8 2f             	cmp    $0x2f,%eax
  800b6f:	77 16                	ja     800b87 <vprintfmt+0x574>
  800b71:	89 c2                	mov    %eax,%edx
  800b73:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b77:	83 c0 08             	add    $0x8,%eax
  800b7a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b7d:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b80:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800b85:	eb 51                	jmp    800bd8 <vprintfmt+0x5c5>
  800b87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b8b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b8f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b93:	eb e8                	jmp    800b7d <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800b95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b99:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b9d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba1:	e9 5c ff ff ff       	jmp    800b02 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800ba6:	4c 89 ee             	mov    %r13,%rsi
  800ba9:	bf 30 00 00 00       	mov    $0x30,%edi
  800bae:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800bb1:	4c 89 ee             	mov    %r13,%rsi
  800bb4:	bf 78 00 00 00       	mov    $0x78,%edi
  800bb9:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800bbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbf:	83 f8 2f             	cmp    $0x2f,%eax
  800bc2:	77 47                	ja     800c0b <vprintfmt+0x5f8>
  800bc4:	89 c2                	mov    %eax,%edx
  800bc6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bca:	83 c0 08             	add    $0x8,%eax
  800bcd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd0:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bd3:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800bd8:	48 83 ec 08          	sub    $0x8,%rsp
  800bdc:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800be0:	0f 94 c0             	sete   %al
  800be3:	0f b6 c0             	movzbl %al,%eax
  800be6:	50                   	push   %rax
  800be7:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800bec:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800bf0:	4c 89 ee             	mov    %r13,%rsi
  800bf3:	4c 89 f7             	mov    %r14,%rdi
  800bf6:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  800bfd:	00 00 00 
  800c00:	ff d0                	call   *%rax
            break;
  800c02:	48 83 c4 10          	add    $0x10,%rsp
  800c06:	e9 3d fa ff ff       	jmp    800648 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800c0b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c13:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c17:	eb b7                	jmp    800bd0 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800c19:	40 84 f6             	test   %sil,%sil
  800c1c:	75 2b                	jne    800c49 <vprintfmt+0x636>
    switch (lflag) {
  800c1e:	85 d2                	test   %edx,%edx
  800c20:	74 56                	je     800c78 <vprintfmt+0x665>
  800c22:	83 fa 01             	cmp    $0x1,%edx
  800c25:	74 7f                	je     800ca6 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800c27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2a:	83 f8 2f             	cmp    $0x2f,%eax
  800c2d:	0f 87 a2 00 00 00    	ja     800cd5 <vprintfmt+0x6c2>
  800c33:	89 c2                	mov    %eax,%edx
  800c35:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c39:	83 c0 08             	add    $0x8,%eax
  800c3c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c3f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c42:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c47:	eb 8f                	jmp    800bd8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4c:	83 f8 2f             	cmp    $0x2f,%eax
  800c4f:	77 19                	ja     800c6a <vprintfmt+0x657>
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c57:	83 c0 08             	add    $0x8,%eax
  800c5a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c5d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c60:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c65:	e9 6e ff ff ff       	jmp    800bd8 <vprintfmt+0x5c5>
  800c6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c76:	eb e5                	jmp    800c5d <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800c78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7b:	83 f8 2f             	cmp    $0x2f,%eax
  800c7e:	77 18                	ja     800c98 <vprintfmt+0x685>
  800c80:	89 c2                	mov    %eax,%edx
  800c82:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c86:	83 c0 08             	add    $0x8,%eax
  800c89:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c8c:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800c8e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800c93:	e9 40 ff ff ff       	jmp    800bd8 <vprintfmt+0x5c5>
  800c98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ca0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca4:	eb e6                	jmp    800c8c <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800ca6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca9:	83 f8 2f             	cmp    $0x2f,%eax
  800cac:	77 19                	ja     800cc7 <vprintfmt+0x6b4>
  800cae:	89 c2                	mov    %eax,%edx
  800cb0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb4:	83 c0 08             	add    $0x8,%eax
  800cb7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cba:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cbd:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800cc2:	e9 11 ff ff ff       	jmp    800bd8 <vprintfmt+0x5c5>
  800cc7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ccb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ccf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd3:	eb e5                	jmp    800cba <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800cd5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cdd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ce1:	e9 59 ff ff ff       	jmp    800c3f <vprintfmt+0x62c>
            putch(ch, put_arg);
  800ce6:	4c 89 ee             	mov    %r13,%rsi
  800ce9:	bf 25 00 00 00       	mov    $0x25,%edi
  800cee:	41 ff d6             	call   *%r14
            break;
  800cf1:	e9 52 f9 ff ff       	jmp    800648 <vprintfmt+0x35>
            putch('%', put_arg);
  800cf6:	4c 89 ee             	mov    %r13,%rsi
  800cf9:	bf 25 00 00 00       	mov    $0x25,%edi
  800cfe:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800d01:	48 83 eb 01          	sub    $0x1,%rbx
  800d05:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800d09:	75 f6                	jne    800d01 <vprintfmt+0x6ee>
  800d0b:	e9 38 f9 ff ff       	jmp    800648 <vprintfmt+0x35>
}
  800d10:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d14:	5b                   	pop    %rbx
  800d15:	41 5c                	pop    %r12
  800d17:	41 5d                	pop    %r13
  800d19:	41 5e                	pop    %r14
  800d1b:	41 5f                	pop    %r15
  800d1d:	5d                   	pop    %rbp
  800d1e:	c3                   	ret

0000000000800d1f <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d1f:	f3 0f 1e fa          	endbr64
  800d23:	55                   	push   %rbp
  800d24:	48 89 e5             	mov    %rsp,%rbp
  800d27:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d2f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800d3f:	48 85 ff             	test   %rdi,%rdi
  800d42:	74 2b                	je     800d6f <vsnprintf+0x50>
  800d44:	48 85 f6             	test   %rsi,%rsi
  800d47:	74 26                	je     800d6f <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800d49:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d4d:	48 bf b6 05 80 00 00 	movabs $0x8005b6,%rdi
  800d54:	00 00 00 
  800d57:	48 b8 13 06 80 00 00 	movabs $0x800613,%rax
  800d5e:	00 00 00 
  800d61:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d67:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800d6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800d6d:	c9                   	leave
  800d6e:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800d6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d74:	eb f7                	jmp    800d6d <vsnprintf+0x4e>

0000000000800d76 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800d76:	f3 0f 1e fa          	endbr64
  800d7a:	55                   	push   %rbp
  800d7b:	48 89 e5             	mov    %rsp,%rbp
  800d7e:	48 83 ec 50          	sub    $0x50,%rsp
  800d82:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d86:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d8a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800d8e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800d95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d99:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d9d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800da1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800da5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800da9:	48 b8 1f 0d 80 00 00 	movabs $0x800d1f,%rax
  800db0:	00 00 00 
  800db3:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800db5:	c9                   	leave
  800db6:	c3                   	ret

0000000000800db7 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800db7:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800dbb:	80 3f 00             	cmpb   $0x0,(%rdi)
  800dbe:	74 10                	je     800dd0 <strlen+0x19>
    size_t n = 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800dc5:	48 83 c0 01          	add    $0x1,%rax
  800dc9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800dcd:	75 f6                	jne    800dc5 <strlen+0xe>
  800dcf:	c3                   	ret
    size_t n = 0;
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800dd5:	c3                   	ret

0000000000800dd6 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800dd6:	f3 0f 1e fa          	endbr64
  800dda:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800ddd:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800de2:	48 85 f6             	test   %rsi,%rsi
  800de5:	74 10                	je     800df7 <strnlen+0x21>
  800de7:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800deb:	74 0b                	je     800df8 <strnlen+0x22>
  800ded:	48 83 c2 01          	add    $0x1,%rdx
  800df1:	48 39 d0             	cmp    %rdx,%rax
  800df4:	75 f1                	jne    800de7 <strnlen+0x11>
  800df6:	c3                   	ret
  800df7:	c3                   	ret
  800df8:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800dfb:	c3                   	ret

0000000000800dfc <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800dfc:	f3 0f 1e fa          	endbr64
  800e00:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e03:	ba 00 00 00 00       	mov    $0x0,%edx
  800e08:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800e0c:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800e0f:	48 83 c2 01          	add    $0x1,%rdx
  800e13:	84 c9                	test   %cl,%cl
  800e15:	75 f1                	jne    800e08 <strcpy+0xc>
        ;
    return res;
}
  800e17:	c3                   	ret

0000000000800e18 <strcat>:

char *
strcat(char *dst, const char *src) {
  800e18:	f3 0f 1e fa          	endbr64
  800e1c:	55                   	push   %rbp
  800e1d:	48 89 e5             	mov    %rsp,%rbp
  800e20:	41 54                	push   %r12
  800e22:	53                   	push   %rbx
  800e23:	48 89 fb             	mov    %rdi,%rbx
  800e26:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e29:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800e30:	00 00 00 
  800e33:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e35:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e39:	4c 89 e6             	mov    %r12,%rsi
  800e3c:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  800e43:	00 00 00 
  800e46:	ff d0                	call   *%rax
    return dst;
}
  800e48:	48 89 d8             	mov    %rbx,%rax
  800e4b:	5b                   	pop    %rbx
  800e4c:	41 5c                	pop    %r12
  800e4e:	5d                   	pop    %rbp
  800e4f:	c3                   	ret

0000000000800e50 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e50:	f3 0f 1e fa          	endbr64
  800e54:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800e57:	48 85 d2             	test   %rdx,%rdx
  800e5a:	74 1f                	je     800e7b <strncpy+0x2b>
  800e5c:	48 01 fa             	add    %rdi,%rdx
  800e5f:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800e62:	48 83 c1 01          	add    $0x1,%rcx
  800e66:	44 0f b6 06          	movzbl (%rsi),%r8d
  800e6a:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e6e:	41 80 f8 01          	cmp    $0x1,%r8b
  800e72:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800e76:	48 39 ca             	cmp    %rcx,%rdx
  800e79:	75 e7                	jne    800e62 <strncpy+0x12>
    }
    return ret;
}
  800e7b:	c3                   	ret

0000000000800e7c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800e7c:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800e80:	48 89 f8             	mov    %rdi,%rax
  800e83:	48 85 d2             	test   %rdx,%rdx
  800e86:	74 24                	je     800eac <strlcpy+0x30>
        while (--size > 0 && *src)
  800e88:	48 83 ea 01          	sub    $0x1,%rdx
  800e8c:	74 1b                	je     800ea9 <strlcpy+0x2d>
  800e8e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e92:	0f b6 16             	movzbl (%rsi),%edx
  800e95:	84 d2                	test   %dl,%dl
  800e97:	74 10                	je     800ea9 <strlcpy+0x2d>
            *dst++ = *src++;
  800e99:	48 83 c6 01          	add    $0x1,%rsi
  800e9d:	48 83 c0 01          	add    $0x1,%rax
  800ea1:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ea4:	48 39 c8             	cmp    %rcx,%rax
  800ea7:	75 e9                	jne    800e92 <strlcpy+0x16>
        *dst = '\0';
  800ea9:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800eac:	48 29 f8             	sub    %rdi,%rax
}
  800eaf:	c3                   	ret

0000000000800eb0 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800eb0:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800eb4:	0f b6 07             	movzbl (%rdi),%eax
  800eb7:	84 c0                	test   %al,%al
  800eb9:	74 13                	je     800ece <strcmp+0x1e>
  800ebb:	38 06                	cmp    %al,(%rsi)
  800ebd:	75 0f                	jne    800ece <strcmp+0x1e>
  800ebf:	48 83 c7 01          	add    $0x1,%rdi
  800ec3:	48 83 c6 01          	add    $0x1,%rsi
  800ec7:	0f b6 07             	movzbl (%rdi),%eax
  800eca:	84 c0                	test   %al,%al
  800ecc:	75 ed                	jne    800ebb <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800ece:	0f b6 c0             	movzbl %al,%eax
  800ed1:	0f b6 16             	movzbl (%rsi),%edx
  800ed4:	29 d0                	sub    %edx,%eax
}
  800ed6:	c3                   	ret

0000000000800ed7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800ed7:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800edb:	48 85 d2             	test   %rdx,%rdx
  800ede:	74 1f                	je     800eff <strncmp+0x28>
  800ee0:	0f b6 07             	movzbl (%rdi),%eax
  800ee3:	84 c0                	test   %al,%al
  800ee5:	74 1e                	je     800f05 <strncmp+0x2e>
  800ee7:	3a 06                	cmp    (%rsi),%al
  800ee9:	75 1a                	jne    800f05 <strncmp+0x2e>
  800eeb:	48 83 c7 01          	add    $0x1,%rdi
  800eef:	48 83 c6 01          	add    $0x1,%rsi
  800ef3:	48 83 ea 01          	sub    $0x1,%rdx
  800ef7:	75 e7                	jne    800ee0 <strncmp+0x9>

    if (!n) return 0;
  800ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  800efe:	c3                   	ret
  800eff:	b8 00 00 00 00       	mov    $0x0,%eax
  800f04:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f05:	0f b6 07             	movzbl (%rdi),%eax
  800f08:	0f b6 16             	movzbl (%rsi),%edx
  800f0b:	29 d0                	sub    %edx,%eax
}
  800f0d:	c3                   	ret

0000000000800f0e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800f0e:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800f12:	0f b6 17             	movzbl (%rdi),%edx
  800f15:	84 d2                	test   %dl,%dl
  800f17:	74 18                	je     800f31 <strchr+0x23>
        if (*str == c) {
  800f19:	0f be d2             	movsbl %dl,%edx
  800f1c:	39 f2                	cmp    %esi,%edx
  800f1e:	74 17                	je     800f37 <strchr+0x29>
    for (; *str; str++) {
  800f20:	48 83 c7 01          	add    $0x1,%rdi
  800f24:	0f b6 17             	movzbl (%rdi),%edx
  800f27:	84 d2                	test   %dl,%dl
  800f29:	75 ee                	jne    800f19 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f30:	c3                   	ret
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	c3                   	ret
            return (char *)str;
  800f37:	48 89 f8             	mov    %rdi,%rax
}
  800f3a:	c3                   	ret

0000000000800f3b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800f3b:	f3 0f 1e fa          	endbr64
  800f3f:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800f42:	0f b6 17             	movzbl (%rdi),%edx
  800f45:	84 d2                	test   %dl,%dl
  800f47:	74 13                	je     800f5c <strfind+0x21>
  800f49:	0f be d2             	movsbl %dl,%edx
  800f4c:	39 f2                	cmp    %esi,%edx
  800f4e:	74 0b                	je     800f5b <strfind+0x20>
  800f50:	48 83 c0 01          	add    $0x1,%rax
  800f54:	0f b6 10             	movzbl (%rax),%edx
  800f57:	84 d2                	test   %dl,%dl
  800f59:	75 ee                	jne    800f49 <strfind+0xe>
        ;
    return (char *)str;
}
  800f5b:	c3                   	ret
  800f5c:	c3                   	ret

0000000000800f5d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800f5d:	f3 0f 1e fa          	endbr64
  800f61:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800f64:	48 89 f8             	mov    %rdi,%rax
  800f67:	48 f7 d8             	neg    %rax
  800f6a:	83 e0 07             	and    $0x7,%eax
  800f6d:	49 89 d1             	mov    %rdx,%r9
  800f70:	49 29 c1             	sub    %rax,%r9
  800f73:	78 36                	js     800fab <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800f75:	40 0f b6 c6          	movzbl %sil,%eax
  800f79:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800f80:	01 01 01 
  800f83:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800f87:	40 f6 c7 07          	test   $0x7,%dil
  800f8b:	75 38                	jne    800fc5 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800f8d:	4c 89 c9             	mov    %r9,%rcx
  800f90:	48 c1 f9 03          	sar    $0x3,%rcx
  800f94:	74 0c                	je     800fa2 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800f96:	fc                   	cld
  800f97:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800f9a:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800f9e:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800fa2:	4d 85 c9             	test   %r9,%r9
  800fa5:	75 45                	jne    800fec <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800fa7:	4c 89 c0             	mov    %r8,%rax
  800faa:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800fab:	48 85 d2             	test   %rdx,%rdx
  800fae:	74 f7                	je     800fa7 <memset+0x4a>
  800fb0:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800fb3:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800fb6:	48 83 c0 01          	add    $0x1,%rax
  800fba:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800fbe:	48 39 c2             	cmp    %rax,%rdx
  800fc1:	75 f3                	jne    800fb6 <memset+0x59>
  800fc3:	eb e2                	jmp    800fa7 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800fc5:	40 f6 c7 01          	test   $0x1,%dil
  800fc9:	74 06                	je     800fd1 <memset+0x74>
  800fcb:	88 07                	mov    %al,(%rdi)
  800fcd:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800fd1:	40 f6 c7 02          	test   $0x2,%dil
  800fd5:	74 07                	je     800fde <memset+0x81>
  800fd7:	66 89 07             	mov    %ax,(%rdi)
  800fda:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fde:	40 f6 c7 04          	test   $0x4,%dil
  800fe2:	74 a9                	je     800f8d <memset+0x30>
  800fe4:	89 07                	mov    %eax,(%rdi)
  800fe6:	48 83 c7 04          	add    $0x4,%rdi
  800fea:	eb a1                	jmp    800f8d <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800fec:	41 f6 c1 04          	test   $0x4,%r9b
  800ff0:	74 1b                	je     80100d <memset+0xb0>
  800ff2:	89 07                	mov    %eax,(%rdi)
  800ff4:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ff8:	41 f6 c1 02          	test   $0x2,%r9b
  800ffc:	74 07                	je     801005 <memset+0xa8>
  800ffe:	66 89 07             	mov    %ax,(%rdi)
  801001:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801005:	41 f6 c1 01          	test   $0x1,%r9b
  801009:	74 9c                	je     800fa7 <memset+0x4a>
  80100b:	eb 06                	jmp    801013 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80100d:	41 f6 c1 02          	test   $0x2,%r9b
  801011:	75 eb                	jne    800ffe <memset+0xa1>
        if (ni & 1) *ptr = k;
  801013:	88 07                	mov    %al,(%rdi)
  801015:	eb 90                	jmp    800fa7 <memset+0x4a>

0000000000801017 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801017:	f3 0f 1e fa          	endbr64
  80101b:	48 89 f8             	mov    %rdi,%rax
  80101e:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801021:	48 39 fe             	cmp    %rdi,%rsi
  801024:	73 3b                	jae    801061 <memmove+0x4a>
  801026:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80102a:	48 39 d7             	cmp    %rdx,%rdi
  80102d:	73 32                	jae    801061 <memmove+0x4a>
        s += n;
        d += n;
  80102f:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801033:	48 89 d6             	mov    %rdx,%rsi
  801036:	48 09 fe             	or     %rdi,%rsi
  801039:	48 09 ce             	or     %rcx,%rsi
  80103c:	40 f6 c6 07          	test   $0x7,%sil
  801040:	75 12                	jne    801054 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801042:	48 83 ef 08          	sub    $0x8,%rdi
  801046:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80104a:	48 c1 e9 03          	shr    $0x3,%rcx
  80104e:	fd                   	std
  80104f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801052:	fc                   	cld
  801053:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801054:	48 83 ef 01          	sub    $0x1,%rdi
  801058:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80105c:	fd                   	std
  80105d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80105f:	eb f1                	jmp    801052 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801061:	48 89 f2             	mov    %rsi,%rdx
  801064:	48 09 c2             	or     %rax,%rdx
  801067:	48 09 ca             	or     %rcx,%rdx
  80106a:	f6 c2 07             	test   $0x7,%dl
  80106d:	75 0c                	jne    80107b <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80106f:	48 c1 e9 03          	shr    $0x3,%rcx
  801073:	48 89 c7             	mov    %rax,%rdi
  801076:	fc                   	cld
  801077:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80107a:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80107b:	48 89 c7             	mov    %rax,%rdi
  80107e:	fc                   	cld
  80107f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801081:	c3                   	ret

0000000000801082 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801082:	f3 0f 1e fa          	endbr64
  801086:	55                   	push   %rbp
  801087:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80108a:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  801091:	00 00 00 
  801094:	ff d0                	call   *%rax
}
  801096:	5d                   	pop    %rbp
  801097:	c3                   	ret

0000000000801098 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801098:	f3 0f 1e fa          	endbr64
  80109c:	55                   	push   %rbp
  80109d:	48 89 e5             	mov    %rsp,%rbp
  8010a0:	41 57                	push   %r15
  8010a2:	41 56                	push   %r14
  8010a4:	41 55                	push   %r13
  8010a6:	41 54                	push   %r12
  8010a8:	53                   	push   %rbx
  8010a9:	48 83 ec 08          	sub    $0x8,%rsp
  8010ad:	49 89 fe             	mov    %rdi,%r14
  8010b0:	49 89 f7             	mov    %rsi,%r15
  8010b3:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8010b6:	48 89 f7             	mov    %rsi,%rdi
  8010b9:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  8010c0:	00 00 00 
  8010c3:	ff d0                	call   *%rax
  8010c5:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8010c8:	48 89 de             	mov    %rbx,%rsi
  8010cb:	4c 89 f7             	mov    %r14,%rdi
  8010ce:	48 b8 d6 0d 80 00 00 	movabs $0x800dd6,%rax
  8010d5:	00 00 00 
  8010d8:	ff d0                	call   *%rax
  8010da:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8010dd:	48 39 c3             	cmp    %rax,%rbx
  8010e0:	74 36                	je     801118 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8010e2:	48 89 d8             	mov    %rbx,%rax
  8010e5:	4c 29 e8             	sub    %r13,%rax
  8010e8:	49 39 c4             	cmp    %rax,%r12
  8010eb:	73 31                	jae    80111e <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8010ed:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8010f2:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8010f6:	4c 89 fe             	mov    %r15,%rsi
  8010f9:	48 b8 82 10 80 00 00 	movabs $0x801082,%rax
  801100:	00 00 00 
  801103:	ff d0                	call   *%rax
    return dstlen + srclen;
  801105:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801109:	48 83 c4 08          	add    $0x8,%rsp
  80110d:	5b                   	pop    %rbx
  80110e:	41 5c                	pop    %r12
  801110:	41 5d                	pop    %r13
  801112:	41 5e                	pop    %r14
  801114:	41 5f                	pop    %r15
  801116:	5d                   	pop    %rbp
  801117:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801118:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80111c:	eb eb                	jmp    801109 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80111e:	48 83 eb 01          	sub    $0x1,%rbx
  801122:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801126:	48 89 da             	mov    %rbx,%rdx
  801129:	4c 89 fe             	mov    %r15,%rsi
  80112c:	48 b8 82 10 80 00 00 	movabs $0x801082,%rax
  801133:	00 00 00 
  801136:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801138:	49 01 de             	add    %rbx,%r14
  80113b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801140:	eb c3                	jmp    801105 <strlcat+0x6d>

0000000000801142 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801142:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801146:	48 85 d2             	test   %rdx,%rdx
  801149:	74 2d                	je     801178 <memcmp+0x36>
  80114b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801150:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801154:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801159:	44 38 c1             	cmp    %r8b,%cl
  80115c:	75 0f                	jne    80116d <memcmp+0x2b>
    while (n-- > 0) {
  80115e:	48 83 c0 01          	add    $0x1,%rax
  801162:	48 39 c2             	cmp    %rax,%rdx
  801165:	75 e9                	jne    801150 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
  80116c:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80116d:	0f b6 c1             	movzbl %cl,%eax
  801170:	45 0f b6 c0          	movzbl %r8b,%r8d
  801174:	44 29 c0             	sub    %r8d,%eax
  801177:	c3                   	ret
    return 0;
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117d:	c3                   	ret

000000000080117e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80117e:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801182:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801186:	48 39 c7             	cmp    %rax,%rdi
  801189:	73 0f                	jae    80119a <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80118b:	40 38 37             	cmp    %sil,(%rdi)
  80118e:	74 0e                	je     80119e <memfind+0x20>
    for (; src < end; src++) {
  801190:	48 83 c7 01          	add    $0x1,%rdi
  801194:	48 39 f8             	cmp    %rdi,%rax
  801197:	75 f2                	jne    80118b <memfind+0xd>
  801199:	c3                   	ret
  80119a:	48 89 f8             	mov    %rdi,%rax
  80119d:	c3                   	ret
  80119e:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8011a1:	c3                   	ret

00000000008011a2 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8011a2:	f3 0f 1e fa          	endbr64
  8011a6:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8011a9:	0f b6 37             	movzbl (%rdi),%esi
  8011ac:	40 80 fe 20          	cmp    $0x20,%sil
  8011b0:	74 06                	je     8011b8 <strtol+0x16>
  8011b2:	40 80 fe 09          	cmp    $0x9,%sil
  8011b6:	75 13                	jne    8011cb <strtol+0x29>
  8011b8:	48 83 c7 01          	add    $0x1,%rdi
  8011bc:	0f b6 37             	movzbl (%rdi),%esi
  8011bf:	40 80 fe 20          	cmp    $0x20,%sil
  8011c3:	74 f3                	je     8011b8 <strtol+0x16>
  8011c5:	40 80 fe 09          	cmp    $0x9,%sil
  8011c9:	74 ed                	je     8011b8 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8011cb:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8011ce:	83 e0 fd             	and    $0xfffffffd,%eax
  8011d1:	3c 01                	cmp    $0x1,%al
  8011d3:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011d7:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8011dd:	75 0f                	jne    8011ee <strtol+0x4c>
  8011df:	80 3f 30             	cmpb   $0x30,(%rdi)
  8011e2:	74 14                	je     8011f8 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8011e4:	85 d2                	test   %edx,%edx
  8011e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011eb:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8011ee:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8011f3:	4c 63 ca             	movslq %edx,%r9
  8011f6:	eb 36                	jmp    80122e <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011f8:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8011fc:	74 0f                	je     80120d <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8011fe:	85 d2                	test   %edx,%edx
  801200:	75 ec                	jne    8011ee <strtol+0x4c>
        s++;
  801202:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801206:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80120b:	eb e1                	jmp    8011ee <strtol+0x4c>
        s += 2;
  80120d:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801211:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801216:	eb d6                	jmp    8011ee <strtol+0x4c>
            dig -= '0';
  801218:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80121b:	44 0f b6 c1          	movzbl %cl,%r8d
  80121f:	41 39 d0             	cmp    %edx,%r8d
  801222:	7d 21                	jge    801245 <strtol+0xa3>
        val = val * base + dig;
  801224:	49 0f af c1          	imul   %r9,%rax
  801228:	0f b6 c9             	movzbl %cl,%ecx
  80122b:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80122e:	48 83 c7 01          	add    $0x1,%rdi
  801232:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801236:	80 f9 39             	cmp    $0x39,%cl
  801239:	76 dd                	jbe    801218 <strtol+0x76>
        else if (dig - 'a' < 27)
  80123b:	80 f9 7b             	cmp    $0x7b,%cl
  80123e:	77 05                	ja     801245 <strtol+0xa3>
            dig -= 'a' - 10;
  801240:	83 e9 57             	sub    $0x57,%ecx
  801243:	eb d6                	jmp    80121b <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801245:	4d 85 d2             	test   %r10,%r10
  801248:	74 03                	je     80124d <strtol+0xab>
  80124a:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80124d:	48 89 c2             	mov    %rax,%rdx
  801250:	48 f7 da             	neg    %rdx
  801253:	40 80 fe 2d          	cmp    $0x2d,%sil
  801257:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80125b:	c3                   	ret

000000000080125c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80125c:	f3 0f 1e fa          	endbr64
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	53                   	push   %rbx
  801265:	48 89 fa             	mov    %rdi,%rdx
  801268:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80126b:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801270:	bb 00 00 00 00       	mov    $0x0,%ebx
  801275:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80127a:	be 00 00 00 00       	mov    $0x0,%esi
  80127f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801285:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801287:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80128b:	c9                   	leave
  80128c:	c3                   	ret

000000000080128d <sys_cgetc>:

int
sys_cgetc(void) {
  80128d:	f3 0f 1e fa          	endbr64
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801296:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80129b:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a0:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012aa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012af:	be 00 00 00 00       	mov    $0x0,%esi
  8012b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ba:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8012bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c0:	c9                   	leave
  8012c1:	c3                   	ret

00000000008012c2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8012c2:	f3 0f 1e fa          	endbr64
  8012c6:	55                   	push   %rbp
  8012c7:	48 89 e5             	mov    %rsp,%rbp
  8012ca:	53                   	push   %rbx
  8012cb:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8012cf:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d2:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e6:	be 00 00 00 00       	mov    $0x0,%esi
  8012eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f3:	48 85 c0             	test   %rax,%rax
  8012f6:	7f 06                	jg     8012fe <sys_env_destroy+0x3c>
}
  8012f8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012fc:	c9                   	leave
  8012fd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012fe:	49 89 c0             	mov    %rax,%r8
  801301:	b9 03 00 00 00       	mov    $0x3,%ecx
  801306:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  80130d:	00 00 00 
  801310:	be 26 00 00 00       	mov    $0x26,%esi
  801315:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  80131c:	00 00 00 
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
  801324:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  80132b:	00 00 00 
  80132e:	41 ff d1             	call   *%r9

0000000000801331 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801331:	f3 0f 1e fa          	endbr64
  801335:	55                   	push   %rbp
  801336:	48 89 e5             	mov    %rsp,%rbp
  801339:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80133a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133f:	ba 00 00 00 00       	mov    $0x0,%edx
  801344:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801349:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801353:	be 00 00 00 00       	mov    $0x0,%esi
  801358:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801360:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801364:	c9                   	leave
  801365:	c3                   	ret

0000000000801366 <sys_yield>:

void
sys_yield(void) {
  801366:	f3 0f 1e fa          	endbr64
  80136a:	55                   	push   %rbp
  80136b:	48 89 e5             	mov    %rsp,%rbp
  80136e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80136f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801374:	ba 00 00 00 00       	mov    $0x0,%edx
  801379:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80137e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801383:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801388:	be 00 00 00 00       	mov    $0x0,%esi
  80138d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801393:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801395:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801399:	c9                   	leave
  80139a:	c3                   	ret

000000000080139b <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80139b:	f3 0f 1e fa          	endbr64
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	53                   	push   %rbx
  8013a4:	48 89 fa             	mov    %rdi,%rdx
  8013a7:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013aa:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013af:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8013b6:	00 00 00 
  8013b9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013be:	be 00 00 00 00       	mov    $0x0,%esi
  8013c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013c9:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8013cb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013cf:	c9                   	leave
  8013d0:	c3                   	ret

00000000008013d1 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8013d1:	f3 0f 1e fa          	endbr64
  8013d5:	55                   	push   %rbp
  8013d6:	48 89 e5             	mov    %rsp,%rbp
  8013d9:	53                   	push   %rbx
  8013da:	49 89 f8             	mov    %rdi,%r8
  8013dd:	48 89 d3             	mov    %rdx,%rbx
  8013e0:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8013e3:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e8:	4c 89 c2             	mov    %r8,%rdx
  8013eb:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ee:	be 00 00 00 00       	mov    $0x0,%esi
  8013f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f9:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8013fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ff:	c9                   	leave
  801400:	c3                   	ret

0000000000801401 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801401:	f3 0f 1e fa          	endbr64
  801405:	55                   	push   %rbp
  801406:	48 89 e5             	mov    %rsp,%rbp
  801409:	53                   	push   %rbx
  80140a:	48 83 ec 08          	sub    $0x8,%rsp
  80140e:	89 f8                	mov    %edi,%eax
  801410:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801413:	48 63 f9             	movslq %ecx,%rdi
  801416:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801419:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80141e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801421:	be 00 00 00 00       	mov    $0x0,%esi
  801426:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80142e:	48 85 c0             	test   %rax,%rax
  801431:	7f 06                	jg     801439 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801433:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801437:	c9                   	leave
  801438:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801439:	49 89 c0             	mov    %rax,%r8
  80143c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801441:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801448:	00 00 00 
  80144b:	be 26 00 00 00       	mov    $0x26,%esi
  801450:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  801457:	00 00 00 
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
  80145f:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  801466:	00 00 00 
  801469:	41 ff d1             	call   *%r9

000000000080146c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80146c:	f3 0f 1e fa          	endbr64
  801470:	55                   	push   %rbp
  801471:	48 89 e5             	mov    %rsp,%rbp
  801474:	53                   	push   %rbx
  801475:	48 83 ec 08          	sub    $0x8,%rsp
  801479:	89 f8                	mov    %edi,%eax
  80147b:	49 89 f2             	mov    %rsi,%r10
  80147e:	48 89 cf             	mov    %rcx,%rdi
  801481:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801484:	48 63 da             	movslq %edx,%rbx
  801487:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80148a:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80148f:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801492:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801495:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801497:	48 85 c0             	test   %rax,%rax
  80149a:	7f 06                	jg     8014a2 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80149c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a0:	c9                   	leave
  8014a1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014a2:	49 89 c0             	mov    %rax,%r8
  8014a5:	b9 05 00 00 00       	mov    $0x5,%ecx
  8014aa:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8014b1:	00 00 00 
  8014b4:	be 26 00 00 00       	mov    $0x26,%esi
  8014b9:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  8014c0:	00 00 00 
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c8:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  8014cf:	00 00 00 
  8014d2:	41 ff d1             	call   *%r9

00000000008014d5 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014d5:	f3 0f 1e fa          	endbr64
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	53                   	push   %rbx
  8014de:	48 83 ec 08          	sub    $0x8,%rsp
  8014e2:	49 89 f9             	mov    %rdi,%r9
  8014e5:	89 f0                	mov    %esi,%eax
  8014e7:	48 89 d3             	mov    %rdx,%rbx
  8014ea:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8014ed:	49 63 f0             	movslq %r8d,%rsi
  8014f0:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014f3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014f8:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801501:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801503:	48 85 c0             	test   %rax,%rax
  801506:	7f 06                	jg     80150e <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801508:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150c:	c9                   	leave
  80150d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80150e:	49 89 c0             	mov    %rax,%r8
  801511:	b9 06 00 00 00       	mov    $0x6,%ecx
  801516:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  80151d:	00 00 00 
  801520:	be 26 00 00 00       	mov    $0x26,%esi
  801525:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  80152c:	00 00 00 
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
  801534:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  80153b:	00 00 00 
  80153e:	41 ff d1             	call   *%r9

0000000000801541 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801541:	f3 0f 1e fa          	endbr64
  801545:	55                   	push   %rbp
  801546:	48 89 e5             	mov    %rsp,%rbp
  801549:	53                   	push   %rbx
  80154a:	48 83 ec 08          	sub    $0x8,%rsp
  80154e:	48 89 f1             	mov    %rsi,%rcx
  801551:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801554:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801557:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80155c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801561:	be 00 00 00 00       	mov    $0x0,%esi
  801566:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80156e:	48 85 c0             	test   %rax,%rax
  801571:	7f 06                	jg     801579 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801573:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801577:	c9                   	leave
  801578:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801579:	49 89 c0             	mov    %rax,%r8
  80157c:	b9 07 00 00 00       	mov    $0x7,%ecx
  801581:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801588:	00 00 00 
  80158b:	be 26 00 00 00       	mov    $0x26,%esi
  801590:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  801597:	00 00 00 
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
  80159f:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  8015a6:	00 00 00 
  8015a9:	41 ff d1             	call   *%r9

00000000008015ac <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8015ac:	f3 0f 1e fa          	endbr64
  8015b0:	55                   	push   %rbp
  8015b1:	48 89 e5             	mov    %rsp,%rbp
  8015b4:	53                   	push   %rbx
  8015b5:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8015b9:	48 63 ce             	movslq %esi,%rcx
  8015bc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015bf:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ce:	be 00 00 00 00       	mov    $0x0,%esi
  8015d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015db:	48 85 c0             	test   %rax,%rax
  8015de:	7f 06                	jg     8015e6 <sys_env_set_status+0x3a>
}
  8015e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015e4:	c9                   	leave
  8015e5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015e6:	49 89 c0             	mov    %rax,%r8
  8015e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ee:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8015f5:	00 00 00 
  8015f8:	be 26 00 00 00       	mov    $0x26,%esi
  8015fd:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  801604:	00 00 00 
  801607:	b8 00 00 00 00       	mov    $0x0,%eax
  80160c:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  801613:	00 00 00 
  801616:	41 ff d1             	call   *%r9

0000000000801619 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801619:	f3 0f 1e fa          	endbr64
  80161d:	55                   	push   %rbp
  80161e:	48 89 e5             	mov    %rsp,%rbp
  801621:	53                   	push   %rbx
  801622:	48 83 ec 08          	sub    $0x8,%rsp
  801626:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801629:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80162c:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801631:	bb 00 00 00 00       	mov    $0x0,%ebx
  801636:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80163b:	be 00 00 00 00       	mov    $0x0,%esi
  801640:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801646:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801648:	48 85 c0             	test   %rax,%rax
  80164b:	7f 06                	jg     801653 <sys_env_set_trapframe+0x3a>
}
  80164d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801651:	c9                   	leave
  801652:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801653:	49 89 c0             	mov    %rax,%r8
  801656:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80165b:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801662:	00 00 00 
  801665:	be 26 00 00 00       	mov    $0x26,%esi
  80166a:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  801671:	00 00 00 
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
  801679:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  801680:	00 00 00 
  801683:	41 ff d1             	call   *%r9

0000000000801686 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801686:	f3 0f 1e fa          	endbr64
  80168a:	55                   	push   %rbp
  80168b:	48 89 e5             	mov    %rsp,%rbp
  80168e:	53                   	push   %rbx
  80168f:	48 83 ec 08          	sub    $0x8,%rsp
  801693:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801696:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801699:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80169e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016a8:	be 00 00 00 00       	mov    $0x0,%esi
  8016ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016b3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016b5:	48 85 c0             	test   %rax,%rax
  8016b8:	7f 06                	jg     8016c0 <sys_env_set_pgfault_upcall+0x3a>
}
  8016ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016be:	c9                   	leave
  8016bf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c0:	49 89 c0             	mov    %rax,%r8
  8016c3:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8016c8:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  8016cf:	00 00 00 
  8016d2:	be 26 00 00 00       	mov    $0x26,%esi
  8016d7:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  8016de:	00 00 00 
  8016e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e6:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  8016ed:	00 00 00 
  8016f0:	41 ff d1             	call   *%r9

00000000008016f3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8016f3:	f3 0f 1e fa          	endbr64
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	53                   	push   %rbx
  8016fc:	89 f8                	mov    %edi,%eax
  8016fe:	49 89 f1             	mov    %rsi,%r9
  801701:	48 89 d3             	mov    %rdx,%rbx
  801704:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801707:	49 63 f0             	movslq %r8d,%rsi
  80170a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80170d:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801712:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801715:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80171b:	cd 30                	int    $0x30
}
  80171d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801721:	c9                   	leave
  801722:	c3                   	ret

0000000000801723 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801723:	f3 0f 1e fa          	endbr64
  801727:	55                   	push   %rbp
  801728:	48 89 e5             	mov    %rsp,%rbp
  80172b:	53                   	push   %rbx
  80172c:	48 83 ec 08          	sub    $0x8,%rsp
  801730:	48 89 fa             	mov    %rdi,%rdx
  801733:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801736:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80173b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801740:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801745:	be 00 00 00 00       	mov    $0x0,%esi
  80174a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801750:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801752:	48 85 c0             	test   %rax,%rax
  801755:	7f 06                	jg     80175d <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801757:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80175b:	c9                   	leave
  80175c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80175d:	49 89 c0             	mov    %rax,%r8
  801760:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801765:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  80176c:	00 00 00 
  80176f:	be 26 00 00 00       	mov    $0x26,%esi
  801774:	48 bf 4a 42 80 00 00 	movabs $0x80424a,%rdi
  80177b:	00 00 00 
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
  801783:	49 b9 57 03 80 00 00 	movabs $0x800357,%r9
  80178a:	00 00 00 
  80178d:	41 ff d1             	call   *%r9

0000000000801790 <sys_gettime>:

int
sys_gettime(void) {
  801790:	f3 0f 1e fa          	endbr64
  801794:	55                   	push   %rbp
  801795:	48 89 e5             	mov    %rsp,%rbp
  801798:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801799:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ad:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017b2:	be 00 00 00 00       	mov    $0x0,%esi
  8017b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017bd:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8017bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017c3:	c9                   	leave
  8017c4:	c3                   	ret

00000000008017c5 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8017c5:	f3 0f 1e fa          	endbr64
  8017c9:	55                   	push   %rbp
  8017ca:	48 89 e5             	mov    %rsp,%rbp
  8017cd:	41 56                	push   %r14
  8017cf:	41 55                	push   %r13
  8017d1:	41 54                	push   %r12
  8017d3:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8017d4:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8017db:	00 00 00 
  8017de:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8017e5:	b8 09 00 00 00       	mov    $0x9,%eax
  8017ea:	cd 30                	int    $0x30
  8017ec:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 7f                	js     801872 <fork+0xad>
  8017f3:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8017f5:	0f 84 83 00 00 00    	je     80187e <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8017fb:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801801:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801808:	00 00 00 
  80180b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801810:	89 c2                	mov    %eax,%edx
  801812:	be 00 00 00 00       	mov    $0x0,%esi
  801817:	bf 00 00 00 00       	mov    $0x0,%edi
  80181c:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  801823:	00 00 00 
  801826:	ff d0                	call   *%rax
  801828:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80182b:	85 c0                	test   %eax,%eax
  80182d:	0f 88 81 00 00 00    	js     8018b4 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801833:	4d 85 f6             	test   %r14,%r14
  801836:	74 20                	je     801858 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801838:	48 be d7 37 80 00 00 	movabs $0x8037d7,%rsi
  80183f:	00 00 00 
  801842:	44 89 e7             	mov    %r12d,%edi
  801845:	48 b8 86 16 80 00 00 	movabs $0x801686,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	call   *%rax
  801851:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801854:	85 c0                	test   %eax,%eax
  801856:	78 70                	js     8018c8 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801858:	be 02 00 00 00       	mov    $0x2,%esi
  80185d:	89 df                	mov    %ebx,%edi
  80185f:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  801866:	00 00 00 
  801869:	ff d0                	call   *%rax
  80186b:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 6a                	js     8018dc <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801872:	44 89 e0             	mov    %r12d,%eax
  801875:	5b                   	pop    %rbx
  801876:	41 5c                	pop    %r12
  801878:	41 5d                	pop    %r13
  80187a:	41 5e                	pop    %r14
  80187c:	5d                   	pop    %rbp
  80187d:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  80187e:	48 b8 31 13 80 00 00 	movabs $0x801331,%rax
  801885:	00 00 00 
  801888:	ff d0                	call   *%rax
  80188a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80188f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801893:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801897:	48 c1 e0 04          	shl    $0x4,%rax
  80189b:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8018a2:	00 00 00 
  8018a5:	48 01 d0             	add    %rdx,%rax
  8018a8:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8018af:	00 00 00 
        return 0;
  8018b2:	eb be                	jmp    801872 <fork+0xad>
        sys_env_destroy(envid);
  8018b4:	44 89 e7             	mov    %r12d,%edi
  8018b7:	48 b8 c2 12 80 00 00 	movabs $0x8012c2,%rax
  8018be:	00 00 00 
  8018c1:	ff d0                	call   *%rax
        return res;
  8018c3:	45 89 ec             	mov    %r13d,%r12d
  8018c6:	eb aa                	jmp    801872 <fork+0xad>
            sys_env_destroy(envid);
  8018c8:	44 89 e7             	mov    %r12d,%edi
  8018cb:	48 b8 c2 12 80 00 00 	movabs $0x8012c2,%rax
  8018d2:	00 00 00 
  8018d5:	ff d0                	call   *%rax
            return res;
  8018d7:	45 89 ec             	mov    %r13d,%r12d
  8018da:	eb 96                	jmp    801872 <fork+0xad>
        sys_env_destroy(envid);
  8018dc:	89 df                	mov    %ebx,%edi
  8018de:	48 b8 c2 12 80 00 00 	movabs $0x8012c2,%rax
  8018e5:	00 00 00 
  8018e8:	ff d0                	call   *%rax
        return res;
  8018ea:	45 89 ec             	mov    %r13d,%r12d
  8018ed:	eb 83                	jmp    801872 <fork+0xad>

00000000008018ef <sfork>:

envid_t
sfork() {
  8018ef:	f3 0f 1e fa          	endbr64
  8018f3:	55                   	push   %rbp
  8018f4:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8018f7:	48 ba 58 42 80 00 00 	movabs $0x804258,%rdx
  8018fe:	00 00 00 
  801901:	be 37 00 00 00       	mov    $0x37,%esi
  801906:	48 bf 73 42 80 00 00 	movabs $0x804273,%rdi
  80190d:	00 00 00 
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
  801915:	48 b9 57 03 80 00 00 	movabs $0x800357,%rcx
  80191c:	00 00 00 
  80191f:	ff d1                	call   *%rcx

0000000000801921 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801921:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801925:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80192c:	ff ff ff 
  80192f:	48 01 f8             	add    %rdi,%rax
  801932:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801936:	c3                   	ret

0000000000801937 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801937:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80193b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801942:	ff ff ff 
  801945:	48 01 f8             	add    %rdi,%rax
  801948:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80194c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801952:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801956:	c3                   	ret

0000000000801957 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801957:	f3 0f 1e fa          	endbr64
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	41 57                	push   %r15
  801961:	41 56                	push   %r14
  801963:	41 55                	push   %r13
  801965:	41 54                	push   %r12
  801967:	53                   	push   %rbx
  801968:	48 83 ec 08          	sub    $0x8,%rsp
  80196c:	49 89 ff             	mov    %rdi,%r15
  80196f:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801974:	49 bd 05 34 80 00 00 	movabs $0x803405,%r13
  80197b:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80197e:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801984:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801987:	48 89 df             	mov    %rbx,%rdi
  80198a:	41 ff d5             	call   *%r13
  80198d:	83 e0 04             	and    $0x4,%eax
  801990:	74 17                	je     8019a9 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801992:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801999:	4c 39 f3             	cmp    %r14,%rbx
  80199c:	75 e6                	jne    801984 <fd_alloc+0x2d>
  80199e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8019a4:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8019a9:	4d 89 27             	mov    %r12,(%r15)
}
  8019ac:	48 83 c4 08          	add    $0x8,%rsp
  8019b0:	5b                   	pop    %rbx
  8019b1:	41 5c                	pop    %r12
  8019b3:	41 5d                	pop    %r13
  8019b5:	41 5e                	pop    %r14
  8019b7:	41 5f                	pop    %r15
  8019b9:	5d                   	pop    %rbp
  8019ba:	c3                   	ret

00000000008019bb <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019bb:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019bf:	83 ff 1f             	cmp    $0x1f,%edi
  8019c2:	77 39                	ja     8019fd <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	41 54                	push   %r12
  8019ca:	53                   	push   %rbx
  8019cb:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019ce:	48 63 df             	movslq %edi,%rbx
  8019d1:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019d8:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019dc:	48 89 df             	mov    %rbx,%rdi
  8019df:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	call   *%rax
  8019eb:	a8 04                	test   $0x4,%al
  8019ed:	74 14                	je     801a03 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8019ef:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f8:	5b                   	pop    %rbx
  8019f9:	41 5c                	pop    %r12
  8019fb:	5d                   	pop    %rbp
  8019fc:	c3                   	ret
        return -E_INVAL;
  8019fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a02:	c3                   	ret
        return -E_INVAL;
  801a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a08:	eb ee                	jmp    8019f8 <fd_lookup+0x3d>

0000000000801a0a <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a0a:	f3 0f 1e fa          	endbr64
  801a0e:	55                   	push   %rbp
  801a0f:	48 89 e5             	mov    %rsp,%rbp
  801a12:	41 54                	push   %r12
  801a14:	53                   	push   %rbx
  801a15:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a18:	48 b8 c0 48 80 00 00 	movabs $0x8048c0,%rax
  801a1f:	00 00 00 
  801a22:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801a29:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a2c:	39 3b                	cmp    %edi,(%rbx)
  801a2e:	74 47                	je     801a77 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801a30:	48 83 c0 08          	add    $0x8,%rax
  801a34:	48 8b 18             	mov    (%rax),%rbx
  801a37:	48 85 db             	test   %rbx,%rbx
  801a3a:	75 f0                	jne    801a2c <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a3c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a43:	00 00 00 
  801a46:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a4c:	89 fa                	mov    %edi,%edx
  801a4e:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  801a55:	00 00 00 
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5d:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  801a64:	00 00 00 
  801a67:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801a69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801a6e:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801a72:	5b                   	pop    %rbx
  801a73:	41 5c                	pop    %r12
  801a75:	5d                   	pop    %rbp
  801a76:	c3                   	ret
            return 0;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7c:	eb f0                	jmp    801a6e <dev_lookup+0x64>

0000000000801a7e <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a7e:	f3 0f 1e fa          	endbr64
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	41 55                	push   %r13
  801a88:	41 54                	push   %r12
  801a8a:	53                   	push   %rbx
  801a8b:	48 83 ec 18          	sub    $0x18,%rsp
  801a8f:	48 89 fb             	mov    %rdi,%rbx
  801a92:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a95:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a9c:	ff ff ff 
  801a9f:	48 01 df             	add    %rbx,%rdi
  801aa2:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801aa6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aaa:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	call   *%rax
  801ab6:	41 89 c5             	mov    %eax,%r13d
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	78 06                	js     801ac3 <fd_close+0x45>
  801abd:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801ac1:	74 1a                	je     801add <fd_close+0x5f>
        return (must_exist ? res : 0);
  801ac3:	45 84 e4             	test   %r12b,%r12b
  801ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  801acb:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801acf:	44 89 e8             	mov    %r13d,%eax
  801ad2:	48 83 c4 18          	add    $0x18,%rsp
  801ad6:	5b                   	pop    %rbx
  801ad7:	41 5c                	pop    %r12
  801ad9:	41 5d                	pop    %r13
  801adb:	5d                   	pop    %rbp
  801adc:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801add:	8b 3b                	mov    (%rbx),%edi
  801adf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ae3:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	call   *%rax
  801aef:	41 89 c5             	mov    %eax,%r13d
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 1b                	js     801b11 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801af6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801afa:	48 8b 40 20          	mov    0x20(%rax),%rax
  801afe:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b04:	48 85 c0             	test   %rax,%rax
  801b07:	74 08                	je     801b11 <fd_close+0x93>
  801b09:	48 89 df             	mov    %rbx,%rdi
  801b0c:	ff d0                	call   *%rax
  801b0e:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b11:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b16:	48 89 de             	mov    %rbx,%rsi
  801b19:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1e:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	call   *%rax
    return res;
  801b2a:	eb a3                	jmp    801acf <fd_close+0x51>

0000000000801b2c <close>:

int
close(int fdnum) {
  801b2c:	f3 0f 1e fa          	endbr64
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
  801b34:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b38:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b3c:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	78 15                	js     801b61 <close+0x35>

    return fd_close(fd, 1);
  801b4c:	be 01 00 00 00       	mov    $0x1,%esi
  801b51:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b55:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	call   *%rax
}
  801b61:	c9                   	leave
  801b62:	c3                   	ret

0000000000801b63 <close_all>:

void
close_all(void) {
  801b63:	f3 0f 1e fa          	endbr64
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
  801b6b:	41 54                	push   %r12
  801b6d:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b73:	49 bc 2c 1b 80 00 00 	movabs $0x801b2c,%r12
  801b7a:	00 00 00 
  801b7d:	89 df                	mov    %ebx,%edi
  801b7f:	41 ff d4             	call   *%r12
  801b82:	83 c3 01             	add    $0x1,%ebx
  801b85:	83 fb 20             	cmp    $0x20,%ebx
  801b88:	75 f3                	jne    801b7d <close_all+0x1a>
}
  801b8a:	5b                   	pop    %rbx
  801b8b:	41 5c                	pop    %r12
  801b8d:	5d                   	pop    %rbp
  801b8e:	c3                   	ret

0000000000801b8f <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b8f:	f3 0f 1e fa          	endbr64
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	41 57                	push   %r15
  801b99:	41 56                	push   %r14
  801b9b:	41 55                	push   %r13
  801b9d:	41 54                	push   %r12
  801b9f:	53                   	push   %rbx
  801ba0:	48 83 ec 18          	sub    $0x18,%rsp
  801ba4:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ba7:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801bab:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801bb2:	00 00 00 
  801bb5:	ff d0                	call   *%rax
  801bb7:	89 c3                	mov    %eax,%ebx
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	0f 88 b8 00 00 00    	js     801c79 <dup+0xea>
    close(newfdnum);
  801bc1:	44 89 e7             	mov    %r12d,%edi
  801bc4:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801bcb:	00 00 00 
  801bce:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bd0:	4d 63 ec             	movslq %r12d,%r13
  801bd3:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801bda:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801bde:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801be2:	4c 89 ff             	mov    %r15,%rdi
  801be5:	49 be 37 19 80 00 00 	movabs $0x801937,%r14
  801bec:	00 00 00 
  801bef:	41 ff d6             	call   *%r14
  801bf2:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bf5:	4c 89 ef             	mov    %r13,%rdi
  801bf8:	41 ff d6             	call   *%r14
  801bfb:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801bfe:	48 89 df             	mov    %rbx,%rdi
  801c01:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c0d:	a8 04                	test   $0x4,%al
  801c0f:	74 2b                	je     801c3c <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c11:	41 89 c1             	mov    %eax,%r9d
  801c14:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c1a:	4c 89 f1             	mov    %r14,%rcx
  801c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c22:	48 89 de             	mov    %rbx,%rsi
  801c25:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2a:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  801c31:	00 00 00 
  801c34:	ff d0                	call   *%rax
  801c36:	89 c3                	mov    %eax,%ebx
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	78 4e                	js     801c8a <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c3c:	4c 89 ff             	mov    %r15,%rdi
  801c3f:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	call   *%rax
  801c4b:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c4e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c54:	4c 89 e9             	mov    %r13,%rcx
  801c57:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5c:	4c 89 fe             	mov    %r15,%rsi
  801c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c64:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  801c6b:	00 00 00 
  801c6e:	ff d0                	call   *%rax
  801c70:	89 c3                	mov    %eax,%ebx
  801c72:	85 c0                	test   %eax,%eax
  801c74:	78 14                	js     801c8a <dup+0xfb>

    return newfdnum;
  801c76:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	48 83 c4 18          	add    $0x18,%rsp
  801c7f:	5b                   	pop    %rbx
  801c80:	41 5c                	pop    %r12
  801c82:	41 5d                	pop    %r13
  801c84:	41 5e                	pop    %r14
  801c86:	41 5f                	pop    %r15
  801c88:	5d                   	pop    %rbp
  801c89:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c8a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c8f:	4c 89 ee             	mov    %r13,%rsi
  801c92:	bf 00 00 00 00       	mov    $0x0,%edi
  801c97:	49 bc 41 15 80 00 00 	movabs $0x801541,%r12
  801c9e:	00 00 00 
  801ca1:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ca4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ca9:	4c 89 f6             	mov    %r14,%rsi
  801cac:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb1:	41 ff d4             	call   *%r12
    return res;
  801cb4:	eb c3                	jmp    801c79 <dup+0xea>

0000000000801cb6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801cb6:	f3 0f 1e fa          	endbr64
  801cba:	55                   	push   %rbp
  801cbb:	48 89 e5             	mov    %rsp,%rbp
  801cbe:	41 56                	push   %r14
  801cc0:	41 55                	push   %r13
  801cc2:	41 54                	push   %r12
  801cc4:	53                   	push   %rbx
  801cc5:	48 83 ec 10          	sub    $0x10,%rsp
  801cc9:	89 fb                	mov    %edi,%ebx
  801ccb:	49 89 f4             	mov    %rsi,%r12
  801cce:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cd1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cd5:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	call   *%rax
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 4c                	js     801d31 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ce5:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801ce9:	41 8b 3e             	mov    (%r14),%edi
  801cec:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cf0:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	call   *%rax
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 35                	js     801d35 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d00:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d04:	83 e0 03             	and    $0x3,%eax
  801d07:	83 f8 01             	cmp    $0x1,%eax
  801d0a:	74 2d                	je     801d39 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d10:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d14:	48 85 c0             	test   %rax,%rax
  801d17:	74 56                	je     801d6f <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d19:	4c 89 ea             	mov    %r13,%rdx
  801d1c:	4c 89 e6             	mov    %r12,%rsi
  801d1f:	4c 89 f7             	mov    %r14,%rdi
  801d22:	ff d0                	call   *%rax
}
  801d24:	48 83 c4 10          	add    $0x10,%rsp
  801d28:	5b                   	pop    %rbx
  801d29:	41 5c                	pop    %r12
  801d2b:	41 5d                	pop    %r13
  801d2d:	41 5e                	pop    %r14
  801d2f:	5d                   	pop    %rbp
  801d30:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d31:	48 98                	cltq
  801d33:	eb ef                	jmp    801d24 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d35:	48 98                	cltq
  801d37:	eb eb                	jmp    801d24 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d39:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d40:	00 00 00 
  801d43:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d49:	89 da                	mov    %ebx,%edx
  801d4b:	48 bf 7e 42 80 00 00 	movabs $0x80427e,%rdi
  801d52:	00 00 00 
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  801d61:	00 00 00 
  801d64:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d66:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d6d:	eb b5                	jmp    801d24 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d6f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d76:	eb ac                	jmp    801d24 <read+0x6e>

0000000000801d78 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d78:	f3 0f 1e fa          	endbr64
  801d7c:	55                   	push   %rbp
  801d7d:	48 89 e5             	mov    %rsp,%rbp
  801d80:	41 57                	push   %r15
  801d82:	41 56                	push   %r14
  801d84:	41 55                	push   %r13
  801d86:	41 54                	push   %r12
  801d88:	53                   	push   %rbx
  801d89:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d8d:	48 85 d2             	test   %rdx,%rdx
  801d90:	74 54                	je     801de6 <readn+0x6e>
  801d92:	41 89 fd             	mov    %edi,%r13d
  801d95:	49 89 f6             	mov    %rsi,%r14
  801d98:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d9b:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801da0:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801da5:	49 bf b6 1c 80 00 00 	movabs $0x801cb6,%r15
  801dac:	00 00 00 
  801daf:	4c 89 e2             	mov    %r12,%rdx
  801db2:	48 29 f2             	sub    %rsi,%rdx
  801db5:	4c 01 f6             	add    %r14,%rsi
  801db8:	44 89 ef             	mov    %r13d,%edi
  801dbb:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 20                	js     801de2 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801dc2:	01 c3                	add    %eax,%ebx
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	74 08                	je     801dd0 <readn+0x58>
  801dc8:	48 63 f3             	movslq %ebx,%rsi
  801dcb:	4c 39 e6             	cmp    %r12,%rsi
  801dce:	72 df                	jb     801daf <readn+0x37>
    }
    return res;
  801dd0:	48 63 c3             	movslq %ebx,%rax
}
  801dd3:	48 83 c4 08          	add    $0x8,%rsp
  801dd7:	5b                   	pop    %rbx
  801dd8:	41 5c                	pop    %r12
  801dda:	41 5d                	pop    %r13
  801ddc:	41 5e                	pop    %r14
  801dde:	41 5f                	pop    %r15
  801de0:	5d                   	pop    %rbp
  801de1:	c3                   	ret
        if (inc < 0) return inc;
  801de2:	48 98                	cltq
  801de4:	eb ed                	jmp    801dd3 <readn+0x5b>
    int inc = 1, res = 0;
  801de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801deb:	eb e3                	jmp    801dd0 <readn+0x58>

0000000000801ded <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ded:	f3 0f 1e fa          	endbr64
  801df1:	55                   	push   %rbp
  801df2:	48 89 e5             	mov    %rsp,%rbp
  801df5:	41 56                	push   %r14
  801df7:	41 55                	push   %r13
  801df9:	41 54                	push   %r12
  801dfb:	53                   	push   %rbx
  801dfc:	48 83 ec 10          	sub    $0x10,%rsp
  801e00:	89 fb                	mov    %edi,%ebx
  801e02:	49 89 f4             	mov    %rsi,%r12
  801e05:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e08:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e0c:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	call   *%rax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	78 47                	js     801e63 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e1c:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e20:	41 8b 3e             	mov    (%r14),%edi
  801e23:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e27:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	call   *%rax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	78 30                	js     801e67 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e37:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e3c:	74 2d                	je     801e6b <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e42:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e46:	48 85 c0             	test   %rax,%rax
  801e49:	74 56                	je     801ea1 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801e4b:	4c 89 ea             	mov    %r13,%rdx
  801e4e:	4c 89 e6             	mov    %r12,%rsi
  801e51:	4c 89 f7             	mov    %r14,%rdi
  801e54:	ff d0                	call   *%rax
}
  801e56:	48 83 c4 10          	add    $0x10,%rsp
  801e5a:	5b                   	pop    %rbx
  801e5b:	41 5c                	pop    %r12
  801e5d:	41 5d                	pop    %r13
  801e5f:	41 5e                	pop    %r14
  801e61:	5d                   	pop    %rbp
  801e62:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e63:	48 98                	cltq
  801e65:	eb ef                	jmp    801e56 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e67:	48 98                	cltq
  801e69:	eb eb                	jmp    801e56 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e6b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e72:	00 00 00 
  801e75:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e7b:	89 da                	mov    %ebx,%edx
  801e7d:	48 bf 9a 42 80 00 00 	movabs $0x80429a,%rdi
  801e84:	00 00 00 
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  801e93:	00 00 00 
  801e96:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e98:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e9f:	eb b5                	jmp    801e56 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ea1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ea8:	eb ac                	jmp    801e56 <write+0x69>

0000000000801eaa <seek>:

int
seek(int fdnum, off_t offset) {
  801eaa:	f3 0f 1e fa          	endbr64
  801eae:	55                   	push   %rbp
  801eaf:	48 89 e5             	mov    %rsp,%rbp
  801eb2:	53                   	push   %rbx
  801eb3:	48 83 ec 18          	sub    $0x18,%rsp
  801eb7:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eb9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ebd:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801ec4:	00 00 00 
  801ec7:	ff d0                	call   *%rax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	78 0c                	js     801ed9 <seek+0x2f>

    fd->fd_offset = offset;
  801ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed1:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801edd:	c9                   	leave
  801ede:	c3                   	ret

0000000000801edf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801edf:	f3 0f 1e fa          	endbr64
  801ee3:	55                   	push   %rbp
  801ee4:	48 89 e5             	mov    %rsp,%rbp
  801ee7:	41 55                	push   %r13
  801ee9:	41 54                	push   %r12
  801eeb:	53                   	push   %rbx
  801eec:	48 83 ec 18          	sub    $0x18,%rsp
  801ef0:	89 fb                	mov    %edi,%ebx
  801ef2:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ef5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ef9:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801f00:	00 00 00 
  801f03:	ff d0                	call   *%rax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	78 38                	js     801f41 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f09:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f0d:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f11:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f15:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801f1c:	00 00 00 
  801f1f:	ff d0                	call   *%rax
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 1c                	js     801f41 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f25:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f2a:	74 20                	je     801f4c <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f30:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f34:	48 85 c0             	test   %rax,%rax
  801f37:	74 47                	je     801f80 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f39:	44 89 e6             	mov    %r12d,%esi
  801f3c:	4c 89 ef             	mov    %r13,%rdi
  801f3f:	ff d0                	call   *%rax
}
  801f41:	48 83 c4 18          	add    $0x18,%rsp
  801f45:	5b                   	pop    %rbx
  801f46:	41 5c                	pop    %r12
  801f48:	41 5d                	pop    %r13
  801f4a:	5d                   	pop    %rbp
  801f4b:	c3                   	ret
                thisenv->env_id, fdnum);
  801f4c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f53:	00 00 00 
  801f56:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f5c:	89 da                	mov    %ebx,%edx
  801f5e:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  801f65:	00 00 00 
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6d:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  801f74:	00 00 00 
  801f77:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7e:	eb c1                	jmp    801f41 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f80:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f85:	eb ba                	jmp    801f41 <ftruncate+0x62>

0000000000801f87 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f87:	f3 0f 1e fa          	endbr64
  801f8b:	55                   	push   %rbp
  801f8c:	48 89 e5             	mov    %rsp,%rbp
  801f8f:	41 54                	push   %r12
  801f91:	53                   	push   %rbx
  801f92:	48 83 ec 10          	sub    $0x10,%rsp
  801f96:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f99:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f9d:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801fa4:	00 00 00 
  801fa7:	ff d0                	call   *%rax
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 4e                	js     801ffb <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fad:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801fb1:	41 8b 3c 24          	mov    (%r12),%edi
  801fb5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fb9:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801fc0:	00 00 00 
  801fc3:	ff d0                	call   *%rax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 32                	js     801ffb <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fcd:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fd2:	74 30                	je     802004 <fstat+0x7d>

    stat->st_name[0] = 0;
  801fd4:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fd7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801fde:	00 00 00 
    stat->st_isdir = 0;
  801fe1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fe8:	00 00 00 
    stat->st_dev = dev;
  801feb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801ff2:	48 89 de             	mov    %rbx,%rsi
  801ff5:	4c 89 e7             	mov    %r12,%rdi
  801ff8:	ff 50 28             	call   *0x28(%rax)
}
  801ffb:	48 83 c4 10          	add    $0x10,%rsp
  801fff:	5b                   	pop    %rbx
  802000:	41 5c                	pop    %r12
  802002:	5d                   	pop    %rbp
  802003:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802004:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802009:	eb f0                	jmp    801ffb <fstat+0x74>

000000000080200b <stat>:

int
stat(const char *path, struct Stat *stat) {
  80200b:	f3 0f 1e fa          	endbr64
  80200f:	55                   	push   %rbp
  802010:	48 89 e5             	mov    %rsp,%rbp
  802013:	41 54                	push   %r12
  802015:	53                   	push   %rbx
  802016:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802019:	be 00 00 00 00       	mov    $0x0,%esi
  80201e:	48 b8 ec 22 80 00 00 	movabs $0x8022ec,%rax
  802025:	00 00 00 
  802028:	ff d0                	call   *%rax
  80202a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80202c:	85 c0                	test   %eax,%eax
  80202e:	78 25                	js     802055 <stat+0x4a>

    int res = fstat(fd, stat);
  802030:	4c 89 e6             	mov    %r12,%rsi
  802033:	89 c7                	mov    %eax,%edi
  802035:	48 b8 87 1f 80 00 00 	movabs $0x801f87,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	call   *%rax
  802041:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802044:	89 df                	mov    %ebx,%edi
  802046:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  80204d:	00 00 00 
  802050:	ff d0                	call   *%rax

    return res;
  802052:	44 89 e3             	mov    %r12d,%ebx
}
  802055:	89 d8                	mov    %ebx,%eax
  802057:	5b                   	pop    %rbx
  802058:	41 5c                	pop    %r12
  80205a:	5d                   	pop    %rbp
  80205b:	c3                   	ret

000000000080205c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80205c:	f3 0f 1e fa          	endbr64
  802060:	55                   	push   %rbp
  802061:	48 89 e5             	mov    %rsp,%rbp
  802064:	41 54                	push   %r12
  802066:	53                   	push   %rbx
  802067:	48 83 ec 10          	sub    $0x10,%rsp
  80206b:	41 89 fc             	mov    %edi,%r12d
  80206e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802071:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802078:	00 00 00 
  80207b:	83 38 00             	cmpl   $0x0,(%rax)
  80207e:	74 6e                	je     8020ee <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802080:	bf 03 00 00 00       	mov    $0x3,%edi
  802085:	48 b8 b8 39 80 00 00 	movabs $0x8039b8,%rax
  80208c:	00 00 00 
  80208f:	ff d0                	call   *%rax
  802091:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802098:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80209a:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8020a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020a5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8020ac:	00 00 00 
  8020af:	44 89 e6             	mov    %r12d,%esi
  8020b2:	89 c7                	mov    %eax,%edi
  8020b4:	48 b8 f6 38 80 00 00 	movabs $0x8038f6,%rax
  8020bb:	00 00 00 
  8020be:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8020c0:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8020c7:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8020c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020d1:	48 89 de             	mov    %rbx,%rsi
  8020d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d9:	48 b8 5d 38 80 00 00 	movabs $0x80385d,%rax
  8020e0:	00 00 00 
  8020e3:	ff d0                	call   *%rax
}
  8020e5:	48 83 c4 10          	add    $0x10,%rsp
  8020e9:	5b                   	pop    %rbx
  8020ea:	41 5c                	pop    %r12
  8020ec:	5d                   	pop    %rbp
  8020ed:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020ee:	bf 03 00 00 00       	mov    $0x3,%edi
  8020f3:	48 b8 b8 39 80 00 00 	movabs $0x8039b8,%rax
  8020fa:	00 00 00 
  8020fd:	ff d0                	call   *%rax
  8020ff:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802106:	00 00 
  802108:	e9 73 ff ff ff       	jmp    802080 <fsipc+0x24>

000000000080210d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80210d:	f3 0f 1e fa          	endbr64
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802115:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80211c:	00 00 00 
  80211f:	8b 57 0c             	mov    0xc(%rdi),%edx
  802122:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802124:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802127:	be 00 00 00 00       	mov    $0x0,%esi
  80212c:	bf 02 00 00 00       	mov    $0x2,%edi
  802131:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802138:	00 00 00 
  80213b:	ff d0                	call   *%rax
}
  80213d:	5d                   	pop    %rbp
  80213e:	c3                   	ret

000000000080213f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80213f:	f3 0f 1e fa          	endbr64
  802143:	55                   	push   %rbp
  802144:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802147:	8b 47 0c             	mov    0xc(%rdi),%eax
  80214a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802151:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802153:	be 00 00 00 00       	mov    $0x0,%esi
  802158:	bf 06 00 00 00       	mov    $0x6,%edi
  80215d:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802164:	00 00 00 
  802167:	ff d0                	call   *%rax
}
  802169:	5d                   	pop    %rbp
  80216a:	c3                   	ret

000000000080216b <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80216b:	f3 0f 1e fa          	endbr64
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	41 54                	push   %r12
  802175:	53                   	push   %rbx
  802176:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802179:	8b 47 0c             	mov    0xc(%rdi),%eax
  80217c:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802183:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802185:	be 00 00 00 00       	mov    $0x0,%esi
  80218a:	bf 05 00 00 00       	mov    $0x5,%edi
  80218f:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802196:	00 00 00 
  802199:	ff d0                	call   *%rax
    if (res < 0) return res;
  80219b:	85 c0                	test   %eax,%eax
  80219d:	78 3d                	js     8021dc <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80219f:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8021a6:	00 00 00 
  8021a9:	4c 89 e6             	mov    %r12,%rsi
  8021ac:	48 89 df             	mov    %rbx,%rdi
  8021af:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021bb:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8021c2:	00 
  8021c3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021c9:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8021d0:	00 
  8021d1:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021dc:	5b                   	pop    %rbx
  8021dd:	41 5c                	pop    %r12
  8021df:	5d                   	pop    %rbp
  8021e0:	c3                   	ret

00000000008021e1 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021e1:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8021e5:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8021ec:	77 41                	ja     80222f <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021ee:	55                   	push   %rbp
  8021ef:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021f2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021f9:	00 00 00 
  8021fc:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8021ff:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802201:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802205:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802209:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  802210:	00 00 00 
  802213:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802215:	be 00 00 00 00       	mov    $0x0,%esi
  80221a:	bf 04 00 00 00       	mov    $0x4,%edi
  80221f:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802226:	00 00 00 
  802229:	ff d0                	call   *%rax
  80222b:	48 98                	cltq
}
  80222d:	5d                   	pop    %rbp
  80222e:	c3                   	ret
        return -E_INVAL;
  80222f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802236:	c3                   	ret

0000000000802237 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802237:	f3 0f 1e fa          	endbr64
  80223b:	55                   	push   %rbp
  80223c:	48 89 e5             	mov    %rsp,%rbp
  80223f:	41 55                	push   %r13
  802241:	41 54                	push   %r12
  802243:	53                   	push   %rbx
  802244:	48 83 ec 08          	sub    $0x8,%rsp
  802248:	49 89 f4             	mov    %rsi,%r12
  80224b:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80224e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802255:	00 00 00 
  802258:	8b 57 0c             	mov    0xc(%rdi),%edx
  80225b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80225d:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802261:	be 00 00 00 00       	mov    $0x0,%esi
  802266:	bf 03 00 00 00       	mov    $0x3,%edi
  80226b:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802272:	00 00 00 
  802275:	ff d0                	call   *%rax
  802277:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80227a:	4d 85 ed             	test   %r13,%r13
  80227d:	78 2a                	js     8022a9 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80227f:	4c 89 ea             	mov    %r13,%rdx
  802282:	4c 39 eb             	cmp    %r13,%rbx
  802285:	72 30                	jb     8022b7 <devfile_read+0x80>
  802287:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80228e:	7f 27                	jg     8022b7 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802290:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802297:	00 00 00 
  80229a:	4c 89 e7             	mov    %r12,%rdi
  80229d:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  8022a4:	00 00 00 
  8022a7:	ff d0                	call   *%rax
}
  8022a9:	4c 89 e8             	mov    %r13,%rax
  8022ac:	48 83 c4 08          	add    $0x8,%rsp
  8022b0:	5b                   	pop    %rbx
  8022b1:	41 5c                	pop    %r12
  8022b3:	41 5d                	pop    %r13
  8022b5:	5d                   	pop    %rbp
  8022b6:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8022b7:	48 b9 b7 42 80 00 00 	movabs $0x8042b7,%rcx
  8022be:	00 00 00 
  8022c1:	48 ba d4 42 80 00 00 	movabs $0x8042d4,%rdx
  8022c8:	00 00 00 
  8022cb:	be 7b 00 00 00       	mov    $0x7b,%esi
  8022d0:	48 bf e9 42 80 00 00 	movabs $0x8042e9,%rdi
  8022d7:	00 00 00 
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  8022e6:	00 00 00 
  8022e9:	41 ff d0             	call   *%r8

00000000008022ec <open>:
open(const char *path, int mode) {
  8022ec:	f3 0f 1e fa          	endbr64
  8022f0:	55                   	push   %rbp
  8022f1:	48 89 e5             	mov    %rsp,%rbp
  8022f4:	41 55                	push   %r13
  8022f6:	41 54                	push   %r12
  8022f8:	53                   	push   %rbx
  8022f9:	48 83 ec 18          	sub    $0x18,%rsp
  8022fd:	49 89 fc             	mov    %rdi,%r12
  802300:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802303:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  80230a:	00 00 00 
  80230d:	ff d0                	call   *%rax
  80230f:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802315:	0f 87 8a 00 00 00    	ja     8023a5 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80231b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80231f:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  802326:	00 00 00 
  802329:	ff d0                	call   *%rax
  80232b:	89 c3                	mov    %eax,%ebx
  80232d:	85 c0                	test   %eax,%eax
  80232f:	78 50                	js     802381 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802331:	4c 89 e6             	mov    %r12,%rsi
  802334:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80233b:	00 00 00 
  80233e:	48 89 df             	mov    %rbx,%rdi
  802341:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  802348:	00 00 00 
  80234b:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80234d:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802354:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802358:	bf 01 00 00 00       	mov    $0x1,%edi
  80235d:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802364:	00 00 00 
  802367:	ff d0                	call   *%rax
  802369:	89 c3                	mov    %eax,%ebx
  80236b:	85 c0                	test   %eax,%eax
  80236d:	78 1f                	js     80238e <open+0xa2>
    return fd2num(fd);
  80236f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802373:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  80237a:	00 00 00 
  80237d:	ff d0                	call   *%rax
  80237f:	89 c3                	mov    %eax,%ebx
}
  802381:	89 d8                	mov    %ebx,%eax
  802383:	48 83 c4 18          	add    $0x18,%rsp
  802387:	5b                   	pop    %rbx
  802388:	41 5c                	pop    %r12
  80238a:	41 5d                	pop    %r13
  80238c:	5d                   	pop    %rbp
  80238d:	c3                   	ret
        fd_close(fd, 0);
  80238e:	be 00 00 00 00       	mov    $0x0,%esi
  802393:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802397:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	call   *%rax
        return res;
  8023a3:	eb dc                	jmp    802381 <open+0x95>
        return -E_BAD_PATH;
  8023a5:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023aa:	eb d5                	jmp    802381 <open+0x95>

00000000008023ac <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023ac:	f3 0f 1e fa          	endbr64
  8023b0:	55                   	push   %rbp
  8023b1:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023b4:	be 00 00 00 00       	mov    $0x0,%esi
  8023b9:	bf 08 00 00 00       	mov    $0x8,%edi
  8023be:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	call   *%rax
}
  8023ca:	5d                   	pop    %rbp
  8023cb:	c3                   	ret

00000000008023cc <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8023cc:	f3 0f 1e fa          	endbr64
  8023d0:	55                   	push   %rbp
  8023d1:	48 89 e5             	mov    %rsp,%rbp
  8023d4:	41 55                	push   %r13
  8023d6:	41 54                	push   %r12
  8023d8:	53                   	push   %rbx
  8023d9:	48 83 ec 08          	sub    $0x8,%rsp
  8023dd:	48 89 fb             	mov    %rdi,%rbx
  8023e0:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8023e3:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8023e6:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	call   *%rax
  8023f2:	41 89 c1             	mov    %eax,%r9d
  8023f5:	4d 89 e0             	mov    %r12,%r8
  8023f8:	49 29 d8             	sub    %rbx,%r8
  8023fb:	48 89 d9             	mov    %rbx,%rcx
  8023fe:	44 89 ea             	mov    %r13d,%edx
  802401:	48 89 de             	mov    %rbx,%rsi
  802404:	bf 00 00 00 00       	mov    $0x0,%edi
  802409:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  802410:	00 00 00 
  802413:	ff d0                	call   *%rax
}
  802415:	48 83 c4 08          	add    $0x8,%rsp
  802419:	5b                   	pop    %rbx
  80241a:	41 5c                	pop    %r12
  80241c:	41 5d                	pop    %r13
  80241e:	5d                   	pop    %rbp
  80241f:	c3                   	ret

0000000000802420 <spawn>:
spawn(const char *prog, const char **argv) {
  802420:	f3 0f 1e fa          	endbr64
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	41 57                	push   %r15
  80242a:	41 56                	push   %r14
  80242c:	41 55                	push   %r13
  80242e:	41 54                	push   %r12
  802430:	53                   	push   %rbx
  802431:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802438:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  80243b:	be 00 00 00 00       	mov    $0x0,%esi
  802440:	48 b8 ec 22 80 00 00 	movabs $0x8022ec,%rax
  802447:	00 00 00 
  80244a:	ff d0                	call   *%rax
  80244c:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  802452:	85 c0                	test   %eax,%eax
  802454:	0f 88 30 06 00 00    	js     802a8a <spawn+0x66a>
  80245a:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  80245c:	ba 00 02 00 00       	mov    $0x200,%edx
  802461:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  802468:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  80246f:	00 00 00 
  802472:	ff d0                	call   *%rax
  802474:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  802476:	3d 00 02 00 00       	cmp    $0x200,%eax
  80247b:	0f 85 7d 02 00 00    	jne    8026fe <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  802481:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  802488:	ff ff 00 
  80248b:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802492:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  802499:	01 01 00 
  80249c:	48 39 d0             	cmp    %rdx,%rax
  80249f:	0f 85 95 02 00 00    	jne    80273a <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  8024a5:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8024ac:	00 3e 00 
  8024af:	0f 85 85 02 00 00    	jne    80273a <spawn+0x31a>
  8024b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8024ba:	cd 30                	int    $0x30
  8024bc:	41 89 c6             	mov    %eax,%r14d
  8024bf:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	0f 88 a9 05 00 00    	js     802a72 <spawn+0x652>
    envid_t child = res;
  8024c9:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8024cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024d4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8024d8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8024dc:	48 c1 e0 04          	shl    $0x4,%rax
  8024e0:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8024e7:	00 00 00 
  8024ea:	48 01 c6             	add    %rax,%rsi
  8024ed:	48 8b 06             	mov    (%rsi),%rax
  8024f0:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8024f7:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8024fe:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  802505:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  80250c:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  802513:	48 29 ce             	sub    %rcx,%rsi
  802516:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  80251c:	c1 e9 03             	shr    $0x3,%ecx
  80251f:	89 c9                	mov    %ecx,%ecx
  802521:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  802524:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80252b:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  802532:	49 8b 3c 24          	mov    (%r12),%rdi
  802536:	48 85 ff             	test   %rdi,%rdi
  802539:	0f 84 7f 05 00 00    	je     802abe <spawn+0x69e>
  80253f:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  802545:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  80254b:	48 bb b7 0d 80 00 00 	movabs $0x800db7,%rbx
  802552:	00 00 00 
  802555:	ff d3                	call   *%rbx
  802557:	4c 01 f8             	add    %r15,%rax
  80255a:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  80255e:	4c 89 ea             	mov    %r13,%rdx
  802561:	49 83 c5 01          	add    $0x1,%r13
  802565:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  80256a:	48 85 ff             	test   %rdi,%rdi
  80256d:	75 e6                	jne    802555 <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  80256f:	49 89 d5             	mov    %rdx,%r13
  802572:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  802579:	48 f7 d0             	not    %rax
  80257c:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802583:	49 89 df             	mov    %rbx,%r15
  802586:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80258a:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802591:	89 d0                	mov    %edx,%eax
  802593:	83 c0 01             	add    $0x1,%eax
  802596:	48 98                	cltq
  802598:	48 c1 e0 03          	shl    $0x3,%rax
  80259c:	49 29 c7             	sub    %rax,%r15
  80259f:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8025a6:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8025aa:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8025b0:	0f 86 ff 04 00 00    	jbe    802ab5 <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8025b6:	b9 06 00 00 00       	mov    $0x6,%ecx
  8025bb:	ba 00 00 01 00       	mov    $0x10000,%edx
  8025c0:	be 00 00 40 00       	mov    $0x400000,%esi
  8025c5:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	call   *%rax
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	0f 88 e1 04 00 00    	js     802aba <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8025d9:	4c 89 e8             	mov    %r13,%rax
  8025dc:	45 85 ed             	test   %r13d,%r13d
  8025df:	7e 54                	jle    802635 <spawn+0x215>
  8025e1:	4d 89 fd             	mov    %r15,%r13
  8025e4:	48 98                	cltq
  8025e6:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  8025ea:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8025f1:	00 00 00 
  8025f4:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8025fb:	ff 
  8025fc:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  802600:	49 8b 34 24          	mov    (%r12),%rsi
  802604:	48 89 df             	mov    %rbx,%rdi
  802607:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  80260e:	00 00 00 
  802611:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  802613:	49 8b 3c 24          	mov    (%r12),%rdi
  802617:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  80261e:	00 00 00 
  802621:	ff d0                	call   *%rax
  802623:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  802628:	49 83 c5 08          	add    $0x8,%r13
  80262c:	49 83 c4 08          	add    $0x8,%r12
  802630:	4d 39 fd             	cmp    %r15,%r13
  802633:	75 b5                	jne    8025ea <spawn+0x1ca>
    argv_store[argc] = 0;
  802635:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  80263c:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802643:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802644:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  80264b:	0f 85 30 01 00 00    	jne    802781 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802651:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802658:	00 00 00 
  80265b:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  802662:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  802669:	ff 
  80266a:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  80266e:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802675:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802679:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802680:	00 00 00 
  802683:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  80268a:	ff 
  80268b:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802692:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802698:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  80269e:	44 89 f2             	mov    %r14d,%edx
  8026a1:	be 00 00 40 00       	mov    $0x400000,%esi
  8026a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ab:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8026b7:	48 bb 41 15 80 00 00 	movabs $0x801541,%rbx
  8026be:	00 00 00 
  8026c1:	ba 00 00 01 00       	mov    $0x10000,%edx
  8026c6:	be 00 00 40 00       	mov    $0x400000,%esi
  8026cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d0:	ff d3                	call   *%rbx
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	78 eb                	js     8026c1 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8026d6:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8026dd:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8026e4:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8026e5:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8026ec:	00 
  8026ed:	0f 84 68 02 00 00    	je     80295b <spawn+0x53b>
  8026f3:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8026f9:	e9 c5 01 00 00       	jmp    8028c3 <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8026fe:	48 bf a8 44 80 00 00 	movabs $0x8044a8,%rdi
  802705:	00 00 00 
  802708:	b8 00 00 00 00       	mov    $0x0,%eax
  80270d:	48 ba b3 04 80 00 00 	movabs $0x8004b3,%rdx
  802714:	00 00 00 
  802717:	ff d2                	call   *%rdx
        close(fd);
  802719:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80271f:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802726:	00 00 00 
  802729:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  80272b:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802732:	ff ff ff 
  802735:	e9 50 03 00 00       	jmp    802a8a <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80273a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80273f:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  802745:	48 bf f4 42 80 00 00 	movabs $0x8042f4,%rdi
  80274c:	00 00 00 
  80274f:	b8 00 00 00 00       	mov    $0x0,%eax
  802754:	48 b9 b3 04 80 00 00 	movabs $0x8004b3,%rcx
  80275b:	00 00 00 
  80275e:	ff d1                	call   *%rcx
        close(fd);
  802760:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802766:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  80276d:	00 00 00 
  802770:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802772:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802779:	ff ff ff 
  80277c:	e9 09 03 00 00       	jmp    802a8a <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802781:	48 b9 d8 44 80 00 00 	movabs $0x8044d8,%rcx
  802788:	00 00 00 
  80278b:	48 ba d4 42 80 00 00 	movabs $0x8042d4,%rdx
  802792:	00 00 00 
  802795:	be f0 00 00 00       	mov    $0xf0,%esi
  80279a:	48 bf 0e 43 80 00 00 	movabs $0x80430e,%rdi
  8027a1:	00 00 00 
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  8027b0:	00 00 00 
  8027b3:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  8027b6:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  8027bc:	83 c9 02             	or     $0x2,%ecx
  8027bf:	48 89 da             	mov    %rbx,%rdx
  8027c2:	be 00 00 40 00       	mov    $0x400000,%esi
  8027c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027cc:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	call   *%rax
        if (res < 0) {
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	0f 88 7e 02 00 00    	js     802a5e <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8027e0:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8027e6:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8027ec:	48 b8 aa 1e 80 00 00 	movabs $0x801eaa,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	call   *%rax
        if (res < 0) {
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	0f 88 a2 02 00 00    	js     802aa2 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  802800:	48 89 da             	mov    %rbx,%rdx
  802803:	be 00 00 40 00       	mov    $0x400000,%esi
  802808:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80280e:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  802815:	00 00 00 
  802818:	ff d0                	call   *%rax
        if (res < 0) {
  80281a:	85 c0                	test   %eax,%eax
  80281c:	0f 88 84 02 00 00    	js     802aa6 <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  802822:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  802829:	49 89 d8             	mov    %rbx,%r8
  80282c:	4c 89 e1             	mov    %r12,%rcx
  80282f:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  802835:	be 00 00 40 00       	mov    $0x400000,%esi
  80283a:	bf 00 00 00 00       	mov    $0x0,%edi
  80283f:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  802846:	00 00 00 
  802849:	ff d0                	call   *%rax
        if (res < 0) {
  80284b:	85 c0                	test   %eax,%eax
  80284d:	0f 88 57 02 00 00    	js     802aaa <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  802853:	48 89 da             	mov    %rbx,%rdx
  802856:	be 00 00 40 00       	mov    $0x400000,%esi
  80285b:	bf 00 00 00 00       	mov    $0x0,%edi
  802860:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  802867:	00 00 00 
  80286a:	ff d0                	call   *%rax
        if (res < 0) {
  80286c:	85 c0                	test   %eax,%eax
  80286e:	0f 89 ca 00 00 00    	jns    80293e <spawn+0x51e>
  802874:	89 c3                	mov    %eax,%ebx
  802876:	e9 e5 01 00 00       	jmp    802a60 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  80287b:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802881:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  802887:	4c 89 ea             	mov    %r13,%rdx
  80288a:	48 29 da             	sub    %rbx,%rdx
  80288d:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  802891:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  802897:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	0f 88 a1 00 00 00    	js     80294c <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8028ab:	49 83 c7 01          	add    $0x1,%r15
  8028af:	49 83 c6 38          	add    $0x38,%r14
  8028b3:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8028ba:	49 39 c7             	cmp    %rax,%r15
  8028bd:	0f 83 98 00 00 00    	jae    80295b <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8028c3:	41 83 3e 01          	cmpl   $0x1,(%r14)
  8028c7:	75 e2                	jne    8028ab <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8028c9:	41 8b 46 04          	mov    0x4(%r14),%eax
  8028cd:	89 c2                	mov    %eax,%edx
  8028cf:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8028d2:	89 d1                	mov    %edx,%ecx
  8028d4:	83 c9 04             	or     $0x4,%ecx
  8028d7:	a8 04                	test   $0x4,%al
  8028d9:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8028dc:	83 e0 01             	and    $0x1,%eax
  8028df:	09 d0                	or     %edx,%eax
  8028e1:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8028e7:	49 8b 46 08          	mov    0x8(%r14),%rax
  8028eb:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  8028f1:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  8028f5:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  8028f9:	4d 8b 66 10          	mov    0x10(%r14),%r12
  8028fd:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  802903:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  802909:	44 89 e2             	mov    %r12d,%edx
  80290c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802912:	74 14                	je     802928 <spawn+0x508>
        va -= res;
  802914:	48 63 ca             	movslq %edx,%rcx
  802917:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  80291a:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  80291d:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  802920:	29 d0                	sub    %edx,%eax
  802922:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  802928:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  80292f:	0f 87 79 01 00 00    	ja     802aae <spawn+0x68e>
    if (filesz != 0) {
  802935:	48 85 db             	test   %rbx,%rbx
  802938:	0f 85 78 fe ff ff    	jne    8027b6 <spawn+0x396>
    if (memsz > filesz) {
  80293e:	4c 39 eb             	cmp    %r13,%rbx
  802941:	0f 83 64 ff ff ff    	jae    8028ab <spawn+0x48b>
  802947:	e9 2f ff ff ff       	jmp    80287b <spawn+0x45b>
        if (res < 0) {
  80294c:	ba 00 00 00 00       	mov    $0x0,%edx
  802951:	0f 4e d0             	cmovle %eax,%edx
  802954:	89 d3                	mov    %edx,%ebx
  802956:	e9 05 01 00 00       	jmp    802a60 <spawn+0x640>
    close(fd);
  80295b:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802961:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802968:	00 00 00 
  80296b:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  80296d:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802974:	48 bf cc 23 80 00 00 	movabs $0x8023cc,%rdi
  80297b:	00 00 00 
  80297e:	48 b8 85 34 80 00 00 	movabs $0x803485,%rax
  802985:	00 00 00 
  802988:	ff d0                	call   *%rax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	78 49                	js     8029d7 <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  80298e:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802995:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80299b:	48 b8 19 16 80 00 00 	movabs $0x801619,%rax
  8029a2:	00 00 00 
  8029a5:	ff d0                	call   *%rax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	78 59                	js     802a04 <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8029ab:	be 02 00 00 00       	mov    $0x2,%esi
  8029b0:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8029b6:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	call   *%rax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	78 6b                	js     802a31 <spawn+0x611>
    return child;
  8029c6:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8029cc:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8029d2:	e9 b3 00 00 00       	jmp    802a8a <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8029d7:	89 c1                	mov    %eax,%ecx
  8029d9:	48 ba 1a 43 80 00 00 	movabs $0x80431a,%rdx
  8029e0:	00 00 00 
  8029e3:	be 84 00 00 00       	mov    $0x84,%esi
  8029e8:	48 bf 0e 43 80 00 00 	movabs $0x80430e,%rdi
  8029ef:	00 00 00 
  8029f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f7:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  8029fe:	00 00 00 
  802a01:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802a04:	89 c1                	mov    %eax,%ecx
  802a06:	48 ba 31 43 80 00 00 	movabs $0x804331,%rdx
  802a0d:	00 00 00 
  802a10:	be 87 00 00 00       	mov    $0x87,%esi
  802a15:	48 bf 0e 43 80 00 00 	movabs $0x80430e,%rdi
  802a1c:	00 00 00 
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a24:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  802a2b:	00 00 00 
  802a2e:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802a31:	89 c1                	mov    %eax,%ecx
  802a33:	48 ba 4b 43 80 00 00 	movabs $0x80434b,%rdx
  802a3a:	00 00 00 
  802a3d:	be 8a 00 00 00       	mov    $0x8a,%esi
  802a42:	48 bf 0e 43 80 00 00 	movabs $0x80430e,%rdi
  802a49:	00 00 00 
  802a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a51:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  802a58:	00 00 00 
  802a5b:	41 ff d0             	call   *%r8
  802a5e:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802a60:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802a66:	48 b8 c2 12 80 00 00 	movabs $0x8012c2,%rax
  802a6d:	00 00 00 
  802a70:	ff d0                	call   *%rax
    close(fd);
  802a72:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802a78:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	call   *%rax
    return res;
  802a84:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  802a8a:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  802a90:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802a97:	5b                   	pop    %rbx
  802a98:	41 5c                	pop    %r12
  802a9a:	41 5d                	pop    %r13
  802a9c:	41 5e                	pop    %r14
  802a9e:	41 5f                	pop    %r15
  802aa0:	5d                   	pop    %rbp
  802aa1:	c3                   	ret
  802aa2:	89 c3                	mov    %eax,%ebx
  802aa4:	eb ba                	jmp    802a60 <spawn+0x640>
  802aa6:	89 c3                	mov    %eax,%ebx
  802aa8:	eb b6                	jmp    802a60 <spawn+0x640>
  802aaa:	89 c3                	mov    %eax,%ebx
  802aac:	eb b2                	jmp    802a60 <spawn+0x640>
        return -E_INVAL;
  802aae:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  802ab3:	eb ab                	jmp    802a60 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802ab5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  802aba:	89 c3                	mov    %eax,%ebx
  802abc:	eb a2                	jmp    802a60 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802abe:	b9 06 00 00 00       	mov    $0x6,%ecx
  802ac3:	ba 00 00 01 00       	mov    $0x10000,%edx
  802ac8:	be 00 00 40 00       	mov    $0x400000,%esi
  802acd:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad2:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802ad9:	00 00 00 
  802adc:	ff d0                	call   *%rax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	78 d8                	js     802aba <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  802ae2:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802ae9:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802aed:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  802af4:	f8 ff 40 00 
  802af8:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802aff:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802b03:	bb 00 00 41 00       	mov    $0x410000,%ebx
  802b08:	e9 28 fb ff ff       	jmp    802635 <spawn+0x215>

0000000000802b0d <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802b0d:	f3 0f 1e fa          	endbr64
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 50          	sub    $0x50,%rsp
  802b19:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802b1d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b21:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802b25:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802b29:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802b30:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b38:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b3c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802b40:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802b45:	eb 15                	jmp    802b5c <spawnl+0x4f>
  802b47:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b4b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802b4f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b53:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802b57:	74 1c                	je     802b75 <spawnl+0x68>
  802b59:	83 c1 01             	add    $0x1,%ecx
  802b5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b5f:	83 f8 2f             	cmp    $0x2f,%eax
  802b62:	77 e3                	ja     802b47 <spawnl+0x3a>
  802b64:	89 c2                	mov    %eax,%edx
  802b66:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802b6a:	4c 01 d2             	add    %r10,%rdx
  802b6d:	83 c0 08             	add    $0x8,%eax
  802b70:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802b73:	eb de                	jmp    802b53 <spawnl+0x46>
    const char *argv[argc + 2];
  802b75:	8d 41 02             	lea    0x2(%rcx),%eax
  802b78:	48 98                	cltq
  802b7a:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802b81:	00 
  802b82:	49 89 c0             	mov    %rax,%r8
  802b85:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  802b89:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802b8f:	48 89 e2             	mov    %rsp,%rdx
  802b92:	48 29 c2             	sub    %rax,%rdx
  802b95:	48 39 d4             	cmp    %rdx,%rsp
  802b98:	74 12                	je     802bac <spawnl+0x9f>
  802b9a:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  802ba1:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  802ba8:	00 00 
  802baa:	eb e9                	jmp    802b95 <spawnl+0x88>
  802bac:	4c 89 c0             	mov    %r8,%rax
  802baf:	25 ff 0f 00 00       	and    $0xfff,%eax
  802bb4:	48 29 c4             	sub    %rax,%rsp
  802bb7:	48 85 c0             	test   %rax,%rax
  802bba:	74 06                	je     802bc2 <spawnl+0xb5>
  802bbc:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  802bc2:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  802bc7:	4c 89 c8             	mov    %r9,%rax
  802bca:	48 c1 e8 03          	shr    $0x3,%rax
  802bce:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  802bd2:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802bd9:	00 
    argv[argc + 1] = NULL;
  802bda:	8d 41 01             	lea    0x1(%rcx),%eax
  802bdd:	48 98                	cltq
  802bdf:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  802be6:	00 
    va_start(vl, arg0);
  802be7:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802bee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bf2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802bf6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bfa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802bfe:	85 c9                	test   %ecx,%ecx
  802c00:	74 41                	je     802c43 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802c02:	49 89 c0             	mov    %rax,%r8
  802c05:	49 8d 41 08          	lea    0x8(%r9),%rax
  802c09:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802c0c:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  802c11:	eb 1b                	jmp    802c2e <spawnl+0x121>
  802c13:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802c17:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802c1b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c1f:	48 8b 11             	mov    (%rcx),%rdx
  802c22:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802c25:	48 83 c0 08          	add    $0x8,%rax
  802c29:	48 39 f0             	cmp    %rsi,%rax
  802c2c:	74 15                	je     802c43 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802c2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c31:	83 fa 2f             	cmp    $0x2f,%edx
  802c34:	77 dd                	ja     802c13 <spawnl+0x106>
  802c36:	89 d1                	mov    %edx,%ecx
  802c38:	4c 01 c1             	add    %r8,%rcx
  802c3b:	83 c2 08             	add    $0x8,%edx
  802c3e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c41:	eb dc                	jmp    802c1f <spawnl+0x112>
    return spawn(prog, argv);
  802c43:	4c 89 ce             	mov    %r9,%rsi
  802c46:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	call   *%rax
}
  802c52:	c9                   	leave
  802c53:	c3                   	ret

0000000000802c54 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802c54:	f3 0f 1e fa          	endbr64
  802c58:	55                   	push   %rbp
  802c59:	48 89 e5             	mov    %rsp,%rbp
  802c5c:	41 54                	push   %r12
  802c5e:	53                   	push   %rbx
  802c5f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802c62:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	call   *%rax
  802c6e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802c71:	48 be 62 43 80 00 00 	movabs $0x804362,%rsi
  802c78:	00 00 00 
  802c7b:	48 89 df             	mov    %rbx,%rdi
  802c7e:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802c8a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802c8f:	41 2b 04 24          	sub    (%r12),%eax
  802c93:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802c99:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802ca0:	00 00 00 
    stat->st_dev = &devpipe;
  802ca3:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802caa:	00 00 00 
  802cad:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb9:	5b                   	pop    %rbx
  802cba:	41 5c                	pop    %r12
  802cbc:	5d                   	pop    %rbp
  802cbd:	c3                   	ret

0000000000802cbe <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802cbe:	f3 0f 1e fa          	endbr64
  802cc2:	55                   	push   %rbp
  802cc3:	48 89 e5             	mov    %rsp,%rbp
  802cc6:	41 54                	push   %r12
  802cc8:	53                   	push   %rbx
  802cc9:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802ccc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cd1:	48 89 fe             	mov    %rdi,%rsi
  802cd4:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd9:	49 bc 41 15 80 00 00 	movabs $0x801541,%r12
  802ce0:	00 00 00 
  802ce3:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802ce6:	48 89 df             	mov    %rbx,%rdi
  802ce9:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802cf0:	00 00 00 
  802cf3:	ff d0                	call   *%rax
  802cf5:	48 89 c6             	mov    %rax,%rsi
  802cf8:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cfd:	bf 00 00 00 00       	mov    $0x0,%edi
  802d02:	41 ff d4             	call   *%r12
}
  802d05:	5b                   	pop    %rbx
  802d06:	41 5c                	pop    %r12
  802d08:	5d                   	pop    %rbp
  802d09:	c3                   	ret

0000000000802d0a <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d0a:	f3 0f 1e fa          	endbr64
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	41 57                	push   %r15
  802d14:	41 56                	push   %r14
  802d16:	41 55                	push   %r13
  802d18:	41 54                	push   %r12
  802d1a:	53                   	push   %rbx
  802d1b:	48 83 ec 18          	sub    $0x18,%rsp
  802d1f:	49 89 fc             	mov    %rdi,%r12
  802d22:	49 89 f5             	mov    %rsi,%r13
  802d25:	49 89 d7             	mov    %rdx,%r15
  802d28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802d2c:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802d38:	4d 85 ff             	test   %r15,%r15
  802d3b:	0f 84 af 00 00 00    	je     802df0 <devpipe_write+0xe6>
  802d41:	48 89 c3             	mov    %rax,%rbx
  802d44:	4c 89 f8             	mov    %r15,%rax
  802d47:	4d 89 ef             	mov    %r13,%r15
  802d4a:	4c 01 e8             	add    %r13,%rax
  802d4d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d51:	49 bd d1 13 80 00 00 	movabs $0x8013d1,%r13
  802d58:	00 00 00 
            sys_yield();
  802d5b:	49 be 66 13 80 00 00 	movabs $0x801366,%r14
  802d62:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d65:	8b 73 04             	mov    0x4(%rbx),%esi
  802d68:	48 63 ce             	movslq %esi,%rcx
  802d6b:	48 63 03             	movslq (%rbx),%rax
  802d6e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802d74:	48 39 c1             	cmp    %rax,%rcx
  802d77:	72 2e                	jb     802da7 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d79:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d7e:	48 89 da             	mov    %rbx,%rdx
  802d81:	be 00 10 00 00       	mov    $0x1000,%esi
  802d86:	4c 89 e7             	mov    %r12,%rdi
  802d89:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 66                	je     802df6 <devpipe_write+0xec>
            sys_yield();
  802d90:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d93:	8b 73 04             	mov    0x4(%rbx),%esi
  802d96:	48 63 ce             	movslq %esi,%rcx
  802d99:	48 63 03             	movslq (%rbx),%rax
  802d9c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802da2:	48 39 c1             	cmp    %rax,%rcx
  802da5:	73 d2                	jae    802d79 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802da7:	41 0f b6 3f          	movzbl (%r15),%edi
  802dab:	48 89 ca             	mov    %rcx,%rdx
  802dae:	48 c1 ea 03          	shr    $0x3,%rdx
  802db2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802db9:	08 10 20 
  802dbc:	48 f7 e2             	mul    %rdx
  802dbf:	48 c1 ea 06          	shr    $0x6,%rdx
  802dc3:	48 89 d0             	mov    %rdx,%rax
  802dc6:	48 c1 e0 09          	shl    $0x9,%rax
  802dca:	48 29 d0             	sub    %rdx,%rax
  802dcd:	48 c1 e0 03          	shl    $0x3,%rax
  802dd1:	48 29 c1             	sub    %rax,%rcx
  802dd4:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802dd9:	83 c6 01             	add    $0x1,%esi
  802ddc:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ddf:	49 83 c7 01          	add    $0x1,%r15
  802de3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802de7:	49 39 c7             	cmp    %rax,%r15
  802dea:	0f 85 75 ff ff ff    	jne    802d65 <devpipe_write+0x5b>
    return n;
  802df0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802df4:	eb 05                	jmp    802dfb <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dfb:	48 83 c4 18          	add    $0x18,%rsp
  802dff:	5b                   	pop    %rbx
  802e00:	41 5c                	pop    %r12
  802e02:	41 5d                	pop    %r13
  802e04:	41 5e                	pop    %r14
  802e06:	41 5f                	pop    %r15
  802e08:	5d                   	pop    %rbp
  802e09:	c3                   	ret

0000000000802e0a <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802e0a:	f3 0f 1e fa          	endbr64
  802e0e:	55                   	push   %rbp
  802e0f:	48 89 e5             	mov    %rsp,%rbp
  802e12:	41 57                	push   %r15
  802e14:	41 56                	push   %r14
  802e16:	41 55                	push   %r13
  802e18:	41 54                	push   %r12
  802e1a:	53                   	push   %rbx
  802e1b:	48 83 ec 18          	sub    $0x18,%rsp
  802e1f:	49 89 fc             	mov    %rdi,%r12
  802e22:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802e26:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e2a:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	call   *%rax
  802e36:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802e39:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e3f:	49 bd d1 13 80 00 00 	movabs $0x8013d1,%r13
  802e46:	00 00 00 
            sys_yield();
  802e49:	49 be 66 13 80 00 00 	movabs $0x801366,%r14
  802e50:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802e53:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802e58:	74 7d                	je     802ed7 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e5a:	8b 03                	mov    (%rbx),%eax
  802e5c:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e5f:	75 26                	jne    802e87 <devpipe_read+0x7d>
            if (i > 0) return i;
  802e61:	4d 85 ff             	test   %r15,%r15
  802e64:	75 77                	jne    802edd <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e66:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e6b:	48 89 da             	mov    %rbx,%rdx
  802e6e:	be 00 10 00 00       	mov    $0x1000,%esi
  802e73:	4c 89 e7             	mov    %r12,%rdi
  802e76:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 72                	je     802eef <devpipe_read+0xe5>
            sys_yield();
  802e7d:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e80:	8b 03                	mov    (%rbx),%eax
  802e82:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e85:	74 df                	je     802e66 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e87:	48 63 c8             	movslq %eax,%rcx
  802e8a:	48 89 ca             	mov    %rcx,%rdx
  802e8d:	48 c1 ea 03          	shr    $0x3,%rdx
  802e91:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802e98:	08 10 20 
  802e9b:	48 89 d0             	mov    %rdx,%rax
  802e9e:	48 f7 e6             	mul    %rsi
  802ea1:	48 c1 ea 06          	shr    $0x6,%rdx
  802ea5:	48 89 d0             	mov    %rdx,%rax
  802ea8:	48 c1 e0 09          	shl    $0x9,%rax
  802eac:	48 29 d0             	sub    %rdx,%rax
  802eaf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802eb6:	00 
  802eb7:	48 89 c8             	mov    %rcx,%rax
  802eba:	48 29 d0             	sub    %rdx,%rax
  802ebd:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802ec2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802ec6:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802eca:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ecd:	49 83 c7 01          	add    $0x1,%r15
  802ed1:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802ed5:	75 83                	jne    802e5a <devpipe_read+0x50>
    return n;
  802ed7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802edb:	eb 03                	jmp    802ee0 <devpipe_read+0xd6>
            if (i > 0) return i;
  802edd:	4c 89 f8             	mov    %r15,%rax
}
  802ee0:	48 83 c4 18          	add    $0x18,%rsp
  802ee4:	5b                   	pop    %rbx
  802ee5:	41 5c                	pop    %r12
  802ee7:	41 5d                	pop    %r13
  802ee9:	41 5e                	pop    %r14
  802eeb:	41 5f                	pop    %r15
  802eed:	5d                   	pop    %rbp
  802eee:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	eb ea                	jmp    802ee0 <devpipe_read+0xd6>

0000000000802ef6 <pipe>:
pipe(int pfd[2]) {
  802ef6:	f3 0f 1e fa          	endbr64
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
  802efe:	41 55                	push   %r13
  802f00:	41 54                	push   %r12
  802f02:	53                   	push   %rbx
  802f03:	48 83 ec 18          	sub    $0x18,%rsp
  802f07:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f0a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802f0e:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	call   *%rax
  802f1a:	89 c3                	mov    %eax,%ebx
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	0f 88 a0 01 00 00    	js     8030c4 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802f24:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f29:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f2e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f32:	bf 00 00 00 00       	mov    $0x0,%edi
  802f37:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802f3e:	00 00 00 
  802f41:	ff d0                	call   *%rax
  802f43:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f45:	85 c0                	test   %eax,%eax
  802f47:	0f 88 77 01 00 00    	js     8030c4 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f4d:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802f51:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  802f58:	00 00 00 
  802f5b:	ff d0                	call   *%rax
  802f5d:	89 c3                	mov    %eax,%ebx
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	0f 88 43 01 00 00    	js     8030aa <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802f67:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f6c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f71:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f75:	bf 00 00 00 00       	mov    $0x0,%edi
  802f7a:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	call   *%rax
  802f86:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	0f 88 1a 01 00 00    	js     8030aa <pipe+0x1b4>
    va = fd2data(fd0);
  802f90:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802f94:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	call   *%rax
  802fa0:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802fa3:	b9 46 00 00 00       	mov    $0x46,%ecx
  802fa8:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fad:	48 89 c6             	mov    %rax,%rsi
  802fb0:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb5:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  802fbc:	00 00 00 
  802fbf:	ff d0                	call   *%rax
  802fc1:	89 c3                	mov    %eax,%ebx
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	0f 88 c5 00 00 00    	js     803090 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802fcb:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802fcf:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  802fd6:	00 00 00 
  802fd9:	ff d0                	call   *%rax
  802fdb:	48 89 c1             	mov    %rax,%rcx
  802fde:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802fe4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802fea:	ba 00 00 00 00       	mov    $0x0,%edx
  802fef:	4c 89 ee             	mov    %r13,%rsi
  802ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff7:	48 b8 6c 14 80 00 00 	movabs $0x80146c,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	call   *%rax
  803003:	89 c3                	mov    %eax,%ebx
  803005:	85 c0                	test   %eax,%eax
  803007:	78 6e                	js     803077 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803009:	be 00 10 00 00       	mov    $0x1000,%esi
  80300e:	4c 89 ef             	mov    %r13,%rdi
  803011:	48 b8 9b 13 80 00 00 	movabs $0x80139b,%rax
  803018:	00 00 00 
  80301b:	ff d0                	call   *%rax
  80301d:	83 f8 02             	cmp    $0x2,%eax
  803020:	0f 85 ab 00 00 00    	jne    8030d1 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  803026:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  80302d:	00 00 
  80302f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803033:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  803035:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803039:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  803040:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803044:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  803046:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80304a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803051:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803055:	48 bb 21 19 80 00 00 	movabs $0x801921,%rbx
  80305c:	00 00 00 
  80305f:	ff d3                	call   *%rbx
  803061:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803065:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803069:	ff d3                	call   *%rbx
  80306b:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803070:	bb 00 00 00 00       	mov    $0x0,%ebx
  803075:	eb 4d                	jmp    8030c4 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803077:	ba 00 10 00 00       	mov    $0x1000,%edx
  80307c:	4c 89 ee             	mov    %r13,%rsi
  80307f:	bf 00 00 00 00       	mov    $0x0,%edi
  803084:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  80308b:	00 00 00 
  80308e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803090:	ba 00 10 00 00       	mov    $0x1000,%edx
  803095:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803099:	bf 00 00 00 00       	mov    $0x0,%edi
  80309e:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8030aa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030af:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8030b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b8:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	call   *%rax
}
  8030c4:	89 d8                	mov    %ebx,%eax
  8030c6:	48 83 c4 18          	add    $0x18,%rsp
  8030ca:	5b                   	pop    %rbx
  8030cb:	41 5c                	pop    %r12
  8030cd:	41 5d                	pop    %r13
  8030cf:	5d                   	pop    %rbp
  8030d0:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8030d1:	48 b9 08 45 80 00 00 	movabs $0x804508,%rcx
  8030d8:	00 00 00 
  8030db:	48 ba d4 42 80 00 00 	movabs $0x8042d4,%rdx
  8030e2:	00 00 00 
  8030e5:	be 2e 00 00 00       	mov    $0x2e,%esi
  8030ea:	48 bf 69 43 80 00 00 	movabs $0x804369,%rdi
  8030f1:	00 00 00 
  8030f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f9:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  803100:	00 00 00 
  803103:	41 ff d0             	call   *%r8

0000000000803106 <pipeisclosed>:
pipeisclosed(int fdnum) {
  803106:	f3 0f 1e fa          	endbr64
  80310a:	55                   	push   %rbp
  80310b:	48 89 e5             	mov    %rsp,%rbp
  80310e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803112:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803116:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  80311d:	00 00 00 
  803120:	ff d0                	call   *%rax
    if (res < 0) return res;
  803122:	85 c0                	test   %eax,%eax
  803124:	78 35                	js     80315b <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  803126:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80312a:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  803131:	00 00 00 
  803134:	ff d0                	call   *%rax
  803136:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803139:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80313e:	be 00 10 00 00       	mov    $0x1000,%esi
  803143:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803147:	48 b8 d1 13 80 00 00 	movabs $0x8013d1,%rax
  80314e:	00 00 00 
  803151:	ff d0                	call   *%rax
  803153:	85 c0                	test   %eax,%eax
  803155:	0f 94 c0             	sete   %al
  803158:	0f b6 c0             	movzbl %al,%eax
}
  80315b:	c9                   	leave
  80315c:	c3                   	ret

000000000080315d <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  80315d:	f3 0f 1e fa          	endbr64
  803161:	55                   	push   %rbp
  803162:	48 89 e5             	mov    %rsp,%rbp
  803165:	41 55                	push   %r13
  803167:	41 54                	push   %r12
  803169:	53                   	push   %rbx
  80316a:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  80316e:	85 ff                	test   %edi,%edi
  803170:	74 7d                	je     8031ef <wait+0x92>
  803172:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803175:	89 f8                	mov    %edi,%eax
  803177:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80317c:	89 fa                	mov    %edi,%edx
  80317e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803184:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  803188:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  80318c:	48 c1 e1 04          	shl    $0x4,%rcx
  803190:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  803197:	00 00 00 
  80319a:	48 01 ca             	add    %rcx,%rdx
  80319d:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  8031a3:	39 d7                	cmp    %edx,%edi
  8031a5:	75 3d                	jne    8031e4 <wait+0x87>
           env->env_status != ENV_FREE) {
  8031a7:	48 98                	cltq
  8031a9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031ad:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8031b1:	48 c1 e0 04          	shl    $0x4,%rax
  8031b5:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  8031bc:	00 00 00 
  8031bf:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  8031c2:	49 bd 66 13 80 00 00 	movabs $0x801366,%r13
  8031c9:	00 00 00 
           env->env_status != ENV_FREE) {
  8031cc:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	74 0e                	je     8031e4 <wait+0x87>
        sys_yield();
  8031d6:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  8031d9:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  8031df:	44 39 e0             	cmp    %r12d,%eax
  8031e2:	74 e8                	je     8031cc <wait+0x6f>
    }
}
  8031e4:	48 83 c4 08          	add    $0x8,%rsp
  8031e8:	5b                   	pop    %rbx
  8031e9:	41 5c                	pop    %r12
  8031eb:	41 5d                	pop    %r13
  8031ed:	5d                   	pop    %rbp
  8031ee:	c3                   	ret
    assert(envid != 0);
  8031ef:	48 b9 79 43 80 00 00 	movabs $0x804379,%rcx
  8031f6:	00 00 00 
  8031f9:	48 ba d4 42 80 00 00 	movabs $0x8042d4,%rdx
  803200:	00 00 00 
  803203:	be 06 00 00 00       	mov    $0x6,%esi
  803208:	48 bf 84 43 80 00 00 	movabs $0x804384,%rdi
  80320f:	00 00 00 
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
  803217:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  80321e:	00 00 00 
  803221:	41 ff d0             	call   *%r8

0000000000803224 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  803224:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803228:	48 89 f8             	mov    %rdi,%rax
  80322b:	48 c1 e8 27          	shr    $0x27,%rax
  80322f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803236:	7f 00 00 
  803239:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80323d:	f6 c2 01             	test   $0x1,%dl
  803240:	74 6d                	je     8032af <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803242:	48 89 f8             	mov    %rdi,%rax
  803245:	48 c1 e8 1e          	shr    $0x1e,%rax
  803249:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803250:	7f 00 00 
  803253:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803257:	f6 c2 01             	test   $0x1,%dl
  80325a:	74 62                	je     8032be <get_uvpt_entry+0x9a>
  80325c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803263:	7f 00 00 
  803266:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80326a:	f6 c2 80             	test   $0x80,%dl
  80326d:	75 4f                	jne    8032be <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80326f:	48 89 f8             	mov    %rdi,%rax
  803272:	48 c1 e8 15          	shr    $0x15,%rax
  803276:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80327d:	7f 00 00 
  803280:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803284:	f6 c2 01             	test   $0x1,%dl
  803287:	74 44                	je     8032cd <get_uvpt_entry+0xa9>
  803289:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803290:	7f 00 00 
  803293:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803297:	f6 c2 80             	test   $0x80,%dl
  80329a:	75 31                	jne    8032cd <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80329c:	48 c1 ef 0c          	shr    $0xc,%rdi
  8032a0:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8032a7:	7f 00 00 
  8032aa:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8032ae:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8032af:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8032b6:	7f 00 00 
  8032b9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032bd:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8032be:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8032c5:	7f 00 00 
  8032c8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032cc:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8032cd:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8032d4:	7f 00 00 
  8032d7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032db:	c3                   	ret

00000000008032dc <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8032dc:	f3 0f 1e fa          	endbr64
  8032e0:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8032e3:	48 89 f9             	mov    %rdi,%rcx
  8032e6:	48 c1 e9 27          	shr    $0x27,%rcx
  8032ea:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8032f1:	7f 00 00 
  8032f4:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8032f8:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8032ff:	f6 c1 01             	test   $0x1,%cl
  803302:	0f 84 b2 00 00 00    	je     8033ba <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803308:	48 89 f9             	mov    %rdi,%rcx
  80330b:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80330f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803316:	7f 00 00 
  803319:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80331d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803324:	40 f6 c6 01          	test   $0x1,%sil
  803328:	0f 84 8c 00 00 00    	je     8033ba <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80332e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803335:	7f 00 00 
  803338:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80333c:	a8 80                	test   $0x80,%al
  80333e:	75 7b                	jne    8033bb <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  803340:	48 89 f9             	mov    %rdi,%rcx
  803343:	48 c1 e9 15          	shr    $0x15,%rcx
  803347:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80334e:	7f 00 00 
  803351:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803355:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80335c:	40 f6 c6 01          	test   $0x1,%sil
  803360:	74 58                	je     8033ba <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  803362:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803369:	7f 00 00 
  80336c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803370:	a8 80                	test   $0x80,%al
  803372:	75 6c                	jne    8033e0 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  803374:	48 89 f9             	mov    %rdi,%rcx
  803377:	48 c1 e9 0c          	shr    $0xc,%rcx
  80337b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803382:	7f 00 00 
  803385:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803389:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  803390:	40 f6 c6 01          	test   $0x1,%sil
  803394:	74 24                	je     8033ba <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  803396:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80339d:	7f 00 00 
  8033a0:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033a4:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033ab:	ff ff 7f 
  8033ae:	48 21 c8             	and    %rcx,%rax
  8033b1:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8033b7:	48 09 d0             	or     %rdx,%rax
}
  8033ba:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8033bb:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8033c2:	7f 00 00 
  8033c5:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033c9:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033d0:	ff ff 7f 
  8033d3:	48 21 c8             	and    %rcx,%rax
  8033d6:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8033dc:	48 01 d0             	add    %rdx,%rax
  8033df:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8033e0:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8033e7:	7f 00 00 
  8033ea:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033ee:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033f5:	ff ff 7f 
  8033f8:	48 21 c8             	and    %rcx,%rax
  8033fb:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  803401:	48 01 d0             	add    %rdx,%rax
  803404:	c3                   	ret

0000000000803405 <get_prot>:

int
get_prot(void *va) {
  803405:	f3 0f 1e fa          	endbr64
  803409:	55                   	push   %rbp
  80340a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80340d:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  803414:	00 00 00 
  803417:	ff d0                	call   *%rax
  803419:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80341c:	83 e0 01             	and    $0x1,%eax
  80341f:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803422:	89 d1                	mov    %edx,%ecx
  803424:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  80342a:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80342c:	89 c1                	mov    %eax,%ecx
  80342e:	83 c9 02             	or     $0x2,%ecx
  803431:	f6 c2 02             	test   $0x2,%dl
  803434:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803437:	89 c1                	mov    %eax,%ecx
  803439:	83 c9 01             	or     $0x1,%ecx
  80343c:	48 85 d2             	test   %rdx,%rdx
  80343f:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803442:	89 c1                	mov    %eax,%ecx
  803444:	83 c9 40             	or     $0x40,%ecx
  803447:	f6 c6 04             	test   $0x4,%dh
  80344a:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80344d:	5d                   	pop    %rbp
  80344e:	c3                   	ret

000000000080344f <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80344f:	f3 0f 1e fa          	endbr64
  803453:	55                   	push   %rbp
  803454:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803457:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  80345e:	00 00 00 
  803461:	ff d0                	call   *%rax
    return pte & PTE_D;
  803463:	48 c1 e8 06          	shr    $0x6,%rax
  803467:	83 e0 01             	and    $0x1,%eax
}
  80346a:	5d                   	pop    %rbp
  80346b:	c3                   	ret

000000000080346c <is_page_present>:

bool
is_page_present(void *va) {
  80346c:	f3 0f 1e fa          	endbr64
  803470:	55                   	push   %rbp
  803471:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803474:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	call   *%rax
  803480:	83 e0 01             	and    $0x1,%eax
}
  803483:	5d                   	pop    %rbp
  803484:	c3                   	ret

0000000000803485 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803485:	f3 0f 1e fa          	endbr64
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
  80348d:	41 57                	push   %r15
  80348f:	41 56                	push   %r14
  803491:	41 55                	push   %r13
  803493:	41 54                	push   %r12
  803495:	53                   	push   %rbx
  803496:	48 83 ec 18          	sub    $0x18,%rsp
  80349a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80349e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8034a2:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8034a7:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8034ae:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8034b1:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8034b8:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8034bb:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8034c2:	00 00 00 
  8034c5:	eb 73                	jmp    80353a <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8034c7:	48 89 d8             	mov    %rbx,%rax
  8034ca:	48 c1 e8 15          	shr    $0x15,%rax
  8034ce:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8034d5:	7f 00 00 
  8034d8:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8034dc:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8034e2:	f6 c2 01             	test   $0x1,%dl
  8034e5:	74 4b                	je     803532 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8034e7:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8034eb:	f6 c2 80             	test   $0x80,%dl
  8034ee:	74 11                	je     803501 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8034f0:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8034f4:	f6 c4 04             	test   $0x4,%ah
  8034f7:	74 39                	je     803532 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8034f9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8034ff:	eb 20                	jmp    803521 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803501:	48 89 da             	mov    %rbx,%rdx
  803504:	48 c1 ea 0c          	shr    $0xc,%rdx
  803508:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80350f:	7f 00 00 
  803512:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  803516:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80351c:	f6 c4 04             	test   $0x4,%ah
  80351f:	74 11                	je     803532 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  803521:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  803525:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803529:	48 89 df             	mov    %rbx,%rdi
  80352c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803530:	ff d0                	call   *%rax
    next:
        va += size;
  803532:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  803535:	49 39 df             	cmp    %rbx,%r15
  803538:	72 3e                	jb     803578 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80353a:	49 8b 06             	mov    (%r14),%rax
  80353d:	a8 01                	test   $0x1,%al
  80353f:	74 37                	je     803578 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803541:	48 89 d8             	mov    %rbx,%rax
  803544:	48 c1 e8 1e          	shr    $0x1e,%rax
  803548:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  80354d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803553:	f6 c2 01             	test   $0x1,%dl
  803556:	74 da                	je     803532 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  803558:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  80355d:	f6 c2 80             	test   $0x80,%dl
  803560:	0f 84 61 ff ff ff    	je     8034c7 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  803566:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80356b:	f6 c4 04             	test   $0x4,%ah
  80356e:	74 c2                	je     803532 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803570:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  803576:	eb a9                	jmp    803521 <foreach_shared_region+0x9c>
    }
    return res;
}
  803578:	b8 00 00 00 00       	mov    $0x0,%eax
  80357d:	48 83 c4 18          	add    $0x18,%rsp
  803581:	5b                   	pop    %rbx
  803582:	41 5c                	pop    %r12
  803584:	41 5d                	pop    %r13
  803586:	41 5e                	pop    %r14
  803588:	41 5f                	pop    %r15
  80358a:	5d                   	pop    %rbp
  80358b:	c3                   	ret

000000000080358c <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80358c:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  803590:	b8 00 00 00 00       	mov    $0x0,%eax
  803595:	c3                   	ret

0000000000803596 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  803596:	f3 0f 1e fa          	endbr64
  80359a:	55                   	push   %rbp
  80359b:	48 89 e5             	mov    %rsp,%rbp
  80359e:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8035a1:	48 be 8f 43 80 00 00 	movabs $0x80438f,%rsi
  8035a8:	00 00 00 
  8035ab:	48 b8 fc 0d 80 00 00 	movabs $0x800dfc,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	call   *%rax
    return 0;
}
  8035b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035bc:	5d                   	pop    %rbp
  8035bd:	c3                   	ret

00000000008035be <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8035be:	f3 0f 1e fa          	endbr64
  8035c2:	55                   	push   %rbp
  8035c3:	48 89 e5             	mov    %rsp,%rbp
  8035c6:	41 57                	push   %r15
  8035c8:	41 56                	push   %r14
  8035ca:	41 55                	push   %r13
  8035cc:	41 54                	push   %r12
  8035ce:	53                   	push   %rbx
  8035cf:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8035d6:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8035dd:	48 85 d2             	test   %rdx,%rdx
  8035e0:	74 7a                	je     80365c <devcons_write+0x9e>
  8035e2:	49 89 d6             	mov    %rdx,%r14
  8035e5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8035eb:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8035f0:	49 bf 17 10 80 00 00 	movabs $0x801017,%r15
  8035f7:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8035fa:	4c 89 f3             	mov    %r14,%rbx
  8035fd:	48 29 f3             	sub    %rsi,%rbx
  803600:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803605:	48 39 c3             	cmp    %rax,%rbx
  803608:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80360c:	4c 63 eb             	movslq %ebx,%r13
  80360f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  803616:	48 01 c6             	add    %rax,%rsi
  803619:	4c 89 ea             	mov    %r13,%rdx
  80361c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803623:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  803626:	4c 89 ee             	mov    %r13,%rsi
  803629:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803630:	48 b8 5c 12 80 00 00 	movabs $0x80125c,%rax
  803637:	00 00 00 
  80363a:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80363c:	41 01 dc             	add    %ebx,%r12d
  80363f:	49 63 f4             	movslq %r12d,%rsi
  803642:	4c 39 f6             	cmp    %r14,%rsi
  803645:	72 b3                	jb     8035fa <devcons_write+0x3c>
    return res;
  803647:	49 63 c4             	movslq %r12d,%rax
}
  80364a:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  803651:	5b                   	pop    %rbx
  803652:	41 5c                	pop    %r12
  803654:	41 5d                	pop    %r13
  803656:	41 5e                	pop    %r14
  803658:	41 5f                	pop    %r15
  80365a:	5d                   	pop    %rbp
  80365b:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  80365c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803662:	eb e3                	jmp    803647 <devcons_write+0x89>

0000000000803664 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803664:	f3 0f 1e fa          	endbr64
  803668:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80366b:	ba 00 00 00 00       	mov    $0x0,%edx
  803670:	48 85 c0             	test   %rax,%rax
  803673:	74 55                	je     8036ca <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803675:	55                   	push   %rbp
  803676:	48 89 e5             	mov    %rsp,%rbp
  803679:	41 55                	push   %r13
  80367b:	41 54                	push   %r12
  80367d:	53                   	push   %rbx
  80367e:	48 83 ec 08          	sub    $0x8,%rsp
  803682:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  803685:	48 bb 8d 12 80 00 00 	movabs $0x80128d,%rbx
  80368c:	00 00 00 
  80368f:	49 bc 66 13 80 00 00 	movabs $0x801366,%r12
  803696:	00 00 00 
  803699:	eb 03                	jmp    80369e <devcons_read+0x3a>
  80369b:	41 ff d4             	call   *%r12
  80369e:	ff d3                	call   *%rbx
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	74 f7                	je     80369b <devcons_read+0x37>
    if (c < 0) return c;
  8036a4:	48 63 d0             	movslq %eax,%rdx
  8036a7:	78 13                	js     8036bc <devcons_read+0x58>
    if (c == 0x04) return 0;
  8036a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8036ae:	83 f8 04             	cmp    $0x4,%eax
  8036b1:	74 09                	je     8036bc <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8036b3:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8036b7:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8036bc:	48 89 d0             	mov    %rdx,%rax
  8036bf:	48 83 c4 08          	add    $0x8,%rsp
  8036c3:	5b                   	pop    %rbx
  8036c4:	41 5c                	pop    %r12
  8036c6:	41 5d                	pop    %r13
  8036c8:	5d                   	pop    %rbp
  8036c9:	c3                   	ret
  8036ca:	48 89 d0             	mov    %rdx,%rax
  8036cd:	c3                   	ret

00000000008036ce <cputchar>:
cputchar(int ch) {
  8036ce:	f3 0f 1e fa          	endbr64
  8036d2:	55                   	push   %rbp
  8036d3:	48 89 e5             	mov    %rsp,%rbp
  8036d6:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8036da:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8036de:	be 01 00 00 00       	mov    $0x1,%esi
  8036e3:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8036e7:	48 b8 5c 12 80 00 00 	movabs $0x80125c,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	call   *%rax
}
  8036f3:	c9                   	leave
  8036f4:	c3                   	ret

00000000008036f5 <getchar>:
getchar(void) {
  8036f5:	f3 0f 1e fa          	endbr64
  8036f9:	55                   	push   %rbp
  8036fa:	48 89 e5             	mov    %rsp,%rbp
  8036fd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803701:	ba 01 00 00 00       	mov    $0x1,%edx
  803706:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80370a:	bf 00 00 00 00       	mov    $0x0,%edi
  80370f:	48 b8 b6 1c 80 00 00 	movabs $0x801cb6,%rax
  803716:	00 00 00 
  803719:	ff d0                	call   *%rax
  80371b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80371d:	85 c0                	test   %eax,%eax
  80371f:	78 06                	js     803727 <getchar+0x32>
  803721:	74 08                	je     80372b <getchar+0x36>
  803723:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803727:	89 d0                	mov    %edx,%eax
  803729:	c9                   	leave
  80372a:	c3                   	ret
    return res < 0 ? res : res ? c :
  80372b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803730:	eb f5                	jmp    803727 <getchar+0x32>

0000000000803732 <iscons>:
iscons(int fdnum) {
  803732:	f3 0f 1e fa          	endbr64
  803736:	55                   	push   %rbp
  803737:	48 89 e5             	mov    %rsp,%rbp
  80373a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80373e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803742:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  803749:	00 00 00 
  80374c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80374e:	85 c0                	test   %eax,%eax
  803750:	78 18                	js     80376a <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  803752:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803756:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  80375d:	00 00 00 
  803760:	8b 00                	mov    (%rax),%eax
  803762:	39 02                	cmp    %eax,(%rdx)
  803764:	0f 94 c0             	sete   %al
  803767:	0f b6 c0             	movzbl %al,%eax
}
  80376a:	c9                   	leave
  80376b:	c3                   	ret

000000000080376c <opencons>:
opencons(void) {
  80376c:	f3 0f 1e fa          	endbr64
  803770:	55                   	push   %rbp
  803771:	48 89 e5             	mov    %rsp,%rbp
  803774:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  803778:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80377c:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  803783:	00 00 00 
  803786:	ff d0                	call   *%rax
  803788:	85 c0                	test   %eax,%eax
  80378a:	78 49                	js     8037d5 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80378c:	b9 46 00 00 00       	mov    $0x46,%ecx
  803791:	ba 00 10 00 00       	mov    $0x1000,%edx
  803796:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80379a:	bf 00 00 00 00       	mov    $0x0,%edi
  80379f:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	call   *%rax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	78 26                	js     8037d5 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8037af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037b3:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  8037ba:	00 00 
  8037bc:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8037be:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8037c2:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8037c9:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  8037d0:	00 00 00 
  8037d3:	ff d0                	call   *%rax
}
  8037d5:	c9                   	leave
  8037d6:	c3                   	ret

00000000008037d7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  8037d7:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  8037da:	48 b8 16 3a 80 00 00 	movabs $0x803a16,%rax
  8037e1:	00 00 00 
    call *%rax
  8037e4:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8037e6:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8037e9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8037f0:	00 
    movq UTRAP_RSP(%rsp), %rsp
  8037f1:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8037f8:	00 
    pushq %rbx
  8037f9:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8037fa:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  803801:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  803804:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  803808:	4c 8b 3c 24          	mov    (%rsp),%r15
  80380c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803811:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803816:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80381b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803820:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803825:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80382a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80382f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803834:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803839:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80383e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803843:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803848:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80384d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803852:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  803856:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80385a:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80385b:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80385c:	c3                   	ret

000000000080385d <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80385d:	f3 0f 1e fa          	endbr64
  803861:	55                   	push   %rbp
  803862:	48 89 e5             	mov    %rsp,%rbp
  803865:	41 54                	push   %r12
  803867:	53                   	push   %rbx
  803868:	48 89 fb             	mov    %rdi,%rbx
  80386b:	48 89 f7             	mov    %rsi,%rdi
  80386e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803871:	48 85 f6             	test   %rsi,%rsi
  803874:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80387b:	00 00 00 
  80387e:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803882:	be 00 10 00 00       	mov    $0x1000,%esi
  803887:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  80388e:	00 00 00 
  803891:	ff d0                	call   *%rax
    if (res < 0) {
  803893:	85 c0                	test   %eax,%eax
  803895:	78 45                	js     8038dc <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803897:	48 85 db             	test   %rbx,%rbx
  80389a:	74 12                	je     8038ae <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80389c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8038a3:	00 00 00 
  8038a6:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8038ac:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  8038ae:	4d 85 e4             	test   %r12,%r12
  8038b1:	74 14                	je     8038c7 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8038b3:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8038ba:	00 00 00 
  8038bd:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8038c3:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8038c7:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8038ce:	00 00 00 
  8038d1:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8038d7:	5b                   	pop    %rbx
  8038d8:	41 5c                	pop    %r12
  8038da:	5d                   	pop    %rbp
  8038db:	c3                   	ret
        if (from_env_store != NULL) {
  8038dc:	48 85 db             	test   %rbx,%rbx
  8038df:	74 06                	je     8038e7 <ipc_recv+0x8a>
            *from_env_store = 0;
  8038e1:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8038e7:	4d 85 e4             	test   %r12,%r12
  8038ea:	74 eb                	je     8038d7 <ipc_recv+0x7a>
            *perm_store = 0;
  8038ec:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8038f3:	00 
  8038f4:	eb e1                	jmp    8038d7 <ipc_recv+0x7a>

00000000008038f6 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8038f6:	f3 0f 1e fa          	endbr64
  8038fa:	55                   	push   %rbp
  8038fb:	48 89 e5             	mov    %rsp,%rbp
  8038fe:	41 57                	push   %r15
  803900:	41 56                	push   %r14
  803902:	41 55                	push   %r13
  803904:	41 54                	push   %r12
  803906:	53                   	push   %rbx
  803907:	48 83 ec 18          	sub    $0x18,%rsp
  80390b:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  80390e:	48 89 d3             	mov    %rdx,%rbx
  803911:	49 89 cc             	mov    %rcx,%r12
  803914:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803917:	48 85 d2             	test   %rdx,%rdx
  80391a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803921:	00 00 00 
  803924:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803928:	89 f0                	mov    %esi,%eax
  80392a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80392e:	48 89 da             	mov    %rbx,%rdx
  803931:	48 89 c6             	mov    %rax,%rsi
  803934:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  80393b:	00 00 00 
  80393e:	ff d0                	call   *%rax
    while (res < 0) {
  803940:	85 c0                	test   %eax,%eax
  803942:	79 65                	jns    8039a9 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803944:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803947:	75 33                	jne    80397c <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803949:	49 bf 66 13 80 00 00 	movabs $0x801366,%r15
  803950:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803953:	49 be f3 16 80 00 00 	movabs $0x8016f3,%r14
  80395a:	00 00 00 
        sys_yield();
  80395d:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803960:	45 89 e8             	mov    %r13d,%r8d
  803963:	4c 89 e1             	mov    %r12,%rcx
  803966:	48 89 da             	mov    %rbx,%rdx
  803969:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80396d:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803970:	41 ff d6             	call   *%r14
    while (res < 0) {
  803973:	85 c0                	test   %eax,%eax
  803975:	79 32                	jns    8039a9 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803977:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80397a:	74 e1                	je     80395d <ipc_send+0x67>
            panic("Error: %i\n", res);
  80397c:	89 c1                	mov    %eax,%ecx
  80397e:	48 ba 9b 43 80 00 00 	movabs $0x80439b,%rdx
  803985:	00 00 00 
  803988:	be 42 00 00 00       	mov    $0x42,%esi
  80398d:	48 bf a6 43 80 00 00 	movabs $0x8043a6,%rdi
  803994:	00 00 00 
  803997:	b8 00 00 00 00       	mov    $0x0,%eax
  80399c:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  8039a3:	00 00 00 
  8039a6:	41 ff d0             	call   *%r8
    }
}
  8039a9:	48 83 c4 18          	add    $0x18,%rsp
  8039ad:	5b                   	pop    %rbx
  8039ae:	41 5c                	pop    %r12
  8039b0:	41 5d                	pop    %r13
  8039b2:	41 5e                	pop    %r14
  8039b4:	41 5f                	pop    %r15
  8039b6:	5d                   	pop    %rbp
  8039b7:	c3                   	ret

00000000008039b8 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8039b8:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8039bc:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8039c1:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8039c8:	00 00 00 
  8039cb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8039cf:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8039d3:	48 c1 e2 04          	shl    $0x4,%rdx
  8039d7:	48 01 ca             	add    %rcx,%rdx
  8039da:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8039e0:	39 fa                	cmp    %edi,%edx
  8039e2:	74 12                	je     8039f6 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8039e4:	48 83 c0 01          	add    $0x1,%rax
  8039e8:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8039ee:	75 db                	jne    8039cb <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8039f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f5:	c3                   	ret
            return envs[i].env_id;
  8039f6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8039fa:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8039fe:	48 c1 e2 04          	shl    $0x4,%rdx
  803a02:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803a09:	00 00 00 
  803a0c:	48 01 d0             	add    %rdx,%rax
  803a0f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a15:	c3                   	ret

0000000000803a16 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  803a16:	f3 0f 1e fa          	endbr64
  803a1a:	55                   	push   %rbp
  803a1b:	48 89 e5             	mov    %rsp,%rbp
  803a1e:	41 56                	push   %r14
  803a20:	41 55                	push   %r13
  803a22:	41 54                	push   %r12
  803a24:	53                   	push   %rbx
  803a25:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a28:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803a2f:	00 00 00 
  803a32:	48 83 38 00          	cmpq   $0x0,(%rax)
  803a36:	74 27                	je     803a5f <_handle_vectored_pagefault+0x49>
  803a38:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803a3d:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  803a44:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a47:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  803a4a:	4c 89 e7             	mov    %r12,%rdi
  803a4d:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803a52:	84 c0                	test   %al,%al
  803a54:	75 45                	jne    803a9b <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a56:	48 83 c3 01          	add    $0x1,%rbx
  803a5a:	49 3b 1e             	cmp    (%r14),%rbx
  803a5d:	72 eb                	jb     803a4a <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803a5f:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  803a66:	00 
  803a67:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803a6c:	4d 8b 04 24          	mov    (%r12),%r8
  803a70:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  803a77:	00 00 00 
  803a7a:	be 1d 00 00 00       	mov    $0x1d,%esi
  803a7f:	48 bf b0 43 80 00 00 	movabs $0x8043b0,%rdi
  803a86:	00 00 00 
  803a89:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8e:	49 ba 57 03 80 00 00 	movabs $0x800357,%r10
  803a95:	00 00 00 
  803a98:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803a9b:	5b                   	pop    %rbx
  803a9c:	41 5c                	pop    %r12
  803a9e:	41 5d                	pop    %r13
  803aa0:	41 5e                	pop    %r14
  803aa2:	5d                   	pop    %rbp
  803aa3:	c3                   	ret

0000000000803aa4 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803aa4:	f3 0f 1e fa          	endbr64
  803aa8:	55                   	push   %rbp
  803aa9:	48 89 e5             	mov    %rsp,%rbp
  803aac:	53                   	push   %rbx
  803aad:	48 83 ec 08          	sub    $0x8,%rsp
  803ab1:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803ab4:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803abb:	00 00 00 
  803abe:	80 38 00             	cmpb   $0x0,(%rax)
  803ac1:	0f 84 84 00 00 00    	je     803b4b <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803ac7:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803ace:	00 00 00 
  803ad1:	48 8b 10             	mov    (%rax),%rdx
  803ad4:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803ad9:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803ae0:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803ae3:	48 85 d2             	test   %rdx,%rdx
  803ae6:	74 19                	je     803b01 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803ae8:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803aec:	0f 84 e8 00 00 00    	je     803bda <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803af2:	48 83 c0 01          	add    $0x1,%rax
  803af6:	48 39 d0             	cmp    %rdx,%rax
  803af9:	75 ed                	jne    803ae8 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803afb:	48 83 fa 08          	cmp    $0x8,%rdx
  803aff:	74 1c                	je     803b1d <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803b01:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803b05:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803b0c:	00 00 00 
  803b0f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803b16:	00 00 00 
  803b19:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803b1d:	48 b8 31 13 80 00 00 	movabs $0x801331,%rax
  803b24:	00 00 00 
  803b27:	ff d0                	call   *%rax
  803b29:	89 c7                	mov    %eax,%edi
  803b2b:	48 be d7 37 80 00 00 	movabs $0x8037d7,%rsi
  803b32:	00 00 00 
  803b35:	48 b8 86 16 80 00 00 	movabs $0x801686,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803b41:	85 c0                	test   %eax,%eax
  803b43:	78 68                	js     803bad <add_pgfault_handler+0x109>
    return res;
}
  803b45:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803b49:	c9                   	leave
  803b4a:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803b4b:	48 b8 31 13 80 00 00 	movabs $0x801331,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	call   *%rax
  803b57:	89 c7                	mov    %eax,%edi
  803b59:	b9 06 00 00 00       	mov    $0x6,%ecx
  803b5e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803b63:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803b6a:	00 00 00 
  803b6d:	48 b8 01 14 80 00 00 	movabs $0x801401,%rax
  803b74:	00 00 00 
  803b77:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803b79:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803b80:	00 00 00 
  803b83:	48 8b 02             	mov    (%rdx),%rax
  803b86:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803b8a:	48 89 0a             	mov    %rcx,(%rdx)
  803b8d:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803b94:	00 00 00 
  803b97:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803b9b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803ba2:	00 00 00 
  803ba5:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803ba8:	e9 70 ff ff ff       	jmp    803b1d <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803bad:	89 c1                	mov    %eax,%ecx
  803baf:	48 ba be 43 80 00 00 	movabs $0x8043be,%rdx
  803bb6:	00 00 00 
  803bb9:	be 3d 00 00 00       	mov    $0x3d,%esi
  803bbe:	48 bf b0 43 80 00 00 	movabs $0x8043b0,%rdi
  803bc5:	00 00 00 
  803bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  803bcd:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  803bd4:	00 00 00 
  803bd7:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803bda:	b8 00 00 00 00       	mov    $0x0,%eax
  803bdf:	e9 61 ff ff ff       	jmp    803b45 <add_pgfault_handler+0xa1>

0000000000803be4 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803be4:	f3 0f 1e fa          	endbr64
  803be8:	55                   	push   %rbp
  803be9:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803bec:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803bf3:	00 00 00 
  803bf6:	80 38 00             	cmpb   $0x0,(%rax)
  803bf9:	74 33                	je     803c2e <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803bfb:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803c02:	00 00 00 
  803c05:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803c0a:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803c11:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803c14:	48 85 c0             	test   %rax,%rax
  803c17:	0f 84 85 00 00 00    	je     803ca2 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  803c1d:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  803c21:	74 40                	je     803c63 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803c23:	48 83 c1 01          	add    $0x1,%rcx
  803c27:	48 39 c1             	cmp    %rax,%rcx
  803c2a:	75 f1                	jne    803c1d <remove_pgfault_handler+0x39>
  803c2c:	eb 74                	jmp    803ca2 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  803c2e:	48 b9 d6 43 80 00 00 	movabs $0x8043d6,%rcx
  803c35:	00 00 00 
  803c38:	48 ba d4 42 80 00 00 	movabs $0x8042d4,%rdx
  803c3f:	00 00 00 
  803c42:	be 43 00 00 00       	mov    $0x43,%esi
  803c47:	48 bf b0 43 80 00 00 	movabs $0x8043b0,%rdi
  803c4e:	00 00 00 
  803c51:	b8 00 00 00 00       	mov    $0x0,%eax
  803c56:	49 b8 57 03 80 00 00 	movabs $0x800357,%r8
  803c5d:	00 00 00 
  803c60:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803c63:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803c6a:	00 
  803c6b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803c6f:	48 29 ca             	sub    %rcx,%rdx
  803c72:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803c79:	00 00 00 
  803c7c:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803c80:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803c85:	48 89 ce             	mov    %rcx,%rsi
  803c88:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	call   *%rax
            _pfhandler_off--;
  803c94:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803c9b:	00 00 00 
  803c9e:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803ca2:	5d                   	pop    %rbp
  803ca3:	c3                   	ret

0000000000803ca4 <__text_end>:
  803ca4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cab:	00 00 00 
  803cae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb5:	00 00 00 
  803cb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbf:	00 00 00 
  803cc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc9:	00 00 00 
  803ccc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd3:	00 00 00 
  803cd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdd:	00 00 00 
  803ce0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce7:	00 00 00 
  803cea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf1:	00 00 00 
  803cf4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfb:	00 00 00 
  803cfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d05:	00 00 00 
  803d08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0f:	00 00 00 
  803d12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d19:	00 00 00 
  803d1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d23:	00 00 00 
  803d26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2d:	00 00 00 
  803d30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d37:	00 00 00 
  803d3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d41:	00 00 00 
  803d44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4b:	00 00 00 
  803d4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d55:	00 00 00 
  803d58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5f:	00 00 00 
  803d62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d69:	00 00 00 
  803d6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d73:	00 00 00 
  803d76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7d:	00 00 00 
  803d80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d87:	00 00 00 
  803d8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d91:	00 00 00 
  803d94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9b:	00 00 00 
  803d9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da5:	00 00 00 
  803da8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803daf:	00 00 00 
  803db2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db9:	00 00 00 
  803dbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc3:	00 00 00 
  803dc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcd:	00 00 00 
  803dd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd7:	00 00 00 
  803dda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de1:	00 00 00 
  803de4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803deb:	00 00 00 
  803dee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df5:	00 00 00 
  803df8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dff:	00 00 00 
  803e02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e09:	00 00 00 
  803e0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e13:	00 00 00 
  803e16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1d:	00 00 00 
  803e20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e27:	00 00 00 
  803e2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e31:	00 00 00 
  803e34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3b:	00 00 00 
  803e3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e45:	00 00 00 
  803e48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4f:	00 00 00 
  803e52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e59:	00 00 00 
  803e5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e63:	00 00 00 
  803e66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6d:	00 00 00 
  803e70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e77:	00 00 00 
  803e7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e81:	00 00 00 
  803e84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8b:	00 00 00 
  803e8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e95:	00 00 00 
  803e98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9f:	00 00 00 
  803ea2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea9:	00 00 00 
  803eac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb3:	00 00 00 
  803eb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebd:	00 00 00 
  803ec0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec7:	00 00 00 
  803eca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed1:	00 00 00 
  803ed4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edb:	00 00 00 
  803ede:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee5:	00 00 00 
  803ee8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eef:	00 00 00 
  803ef2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef9:	00 00 00 
  803efc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f03:	00 00 00 
  803f06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0d:	00 00 00 
  803f10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f17:	00 00 00 
  803f1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f21:	00 00 00 
  803f24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2b:	00 00 00 
  803f2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f35:	00 00 00 
  803f38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3f:	00 00 00 
  803f42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f49:	00 00 00 
  803f4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f53:	00 00 00 
  803f56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5d:	00 00 00 
  803f60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f67:	00 00 00 
  803f6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f71:	00 00 00 
  803f74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7b:	00 00 00 
  803f7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f85:	00 00 00 
  803f88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8f:	00 00 00 
  803f92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f99:	00 00 00 
  803f9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa3:	00 00 00 
  803fa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fad:	00 00 00 
  803fb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb7:	00 00 00 
  803fba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc1:	00 00 00 
  803fc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcb:	00 00 00 
  803fce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd5:	00 00 00 
  803fd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdf:	00 00 00 
  803fe2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe9:	00 00 00 
  803fec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff3:	00 00 00 
  803ff6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ffd:	00 00 00 
