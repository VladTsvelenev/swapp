
obj/user/testbss:     file format elf64-x86-64


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
  80001e:	e8 39 01 00 00       	call   80015c <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#define ARRAYSIZE (1024 * 1024)

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    int i;

    cprintf("Making sure bss works right...\n");
  80002d:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800034:	00 00 00 
  800037:	b8 00 00 00 00       	mov    $0x0,%eax
  80003c:	48 ba 91 03 80 00 00 	movabs $0x800391,%rdx
  800043:	00 00 00 
  800046:	ff d2                	call   *%rdx
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
    for (i = 0; i < ARRAYSIZE; i++)
        if (bigarray[i] != 0)
  80004d:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800054:	00 00 00 
  800057:	83 3c 88 00          	cmpl   $0x0,(%rax,%rcx,4)
  80005b:	0f 85 a5 00 00 00    	jne    800106 <umain+0xe1>
    for (i = 0; i < ARRAYSIZE; i++)
  800061:	48 83 c1 01          	add    $0x1,%rcx
  800065:	48 81 f9 00 00 10 00 	cmp    $0x100000,%rcx
  80006c:	75 e9                	jne    800057 <umain+0x32>
  80006e:	b8 00 00 00 00       	mov    $0x0,%eax
            panic("bigarray[%d] isn't cleared!\n", i);
    for (i = 0; i < ARRAYSIZE; i++)
        bigarray[i] = i;
  800073:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  80007a:	00 00 00 
  80007d:	89 04 82             	mov    %eax,(%rdx,%rax,4)
    for (i = 0; i < ARRAYSIZE; i++)
  800080:	48 83 c0 01          	add    $0x1,%rax
  800084:	48 3d 00 00 10 00    	cmp    $0x100000,%rax
  80008a:	75 f1                	jne    80007d <umain+0x58>
  80008c:	b9 00 00 00 00       	mov    $0x0,%ecx
    for (i = 0; i < ARRAYSIZE; i++)
        if (bigarray[i] != i)
  800091:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800098:	00 00 00 
  80009b:	39 0c 88             	cmp    %ecx,(%rax,%rcx,4)
  80009e:	0f 85 8d 00 00 00    	jne    800131 <umain+0x10c>
    for (i = 0; i < ARRAYSIZE; i++)
  8000a4:	48 83 c1 01          	add    $0x1,%rcx
  8000a8:	48 81 f9 00 00 10 00 	cmp    $0x100000,%rcx
  8000af:	75 ea                	jne    80009b <umain+0x76>
            panic("bigarray[%d] didn't hold its value!\n", i);

    cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000b1:	48 bf 48 30 80 00 00 	movabs $0x803048,%rdi
  8000b8:	00 00 00 
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	48 ba 91 03 80 00 00 	movabs $0x800391,%rdx
  8000c7:	00 00 00 
  8000ca:	ff d2                	call   *%rdx

    /* Accessing via subscript operator ([]) will result in -Warray-bounds warning. */
    *((volatile uint32_t *)bigarray + ARRAYSIZE + 0x800000) = 0;
  8000cc:	48 b8 00 50 c0 02 00 	movabs $0x2c05000,%rax
  8000d3:	00 00 00 
  8000d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    panic("SHOULD HAVE TRAPPED!!!");
  8000dc:	48 ba 80 31 80 00 00 	movabs $0x803180,%rdx
  8000e3:	00 00 00 
  8000e6:	be 1b 00 00 00       	mov    $0x1b,%esi
  8000eb:	48 bf 71 31 80 00 00 	movabs $0x803171,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 b9 35 02 80 00 00 	movabs $0x800235,%rcx
  800101:	00 00 00 
  800104:	ff d1                	call   *%rcx
            panic("bigarray[%d] isn't cleared!\n", i);
  800106:	48 ba 54 31 80 00 00 	movabs $0x803154,%rdx
  80010d:	00 00 00 
  800110:	be 10 00 00 00       	mov    $0x10,%esi
  800115:	48 bf 71 31 80 00 00 	movabs $0x803171,%rdi
  80011c:	00 00 00 
  80011f:	b8 00 00 00 00       	mov    $0x0,%eax
  800124:	49 b8 35 02 80 00 00 	movabs $0x800235,%r8
  80012b:	00 00 00 
  80012e:	41 ff d0             	call   *%r8
            panic("bigarray[%d] didn't hold its value!\n", i);
  800131:	48 ba 20 30 80 00 00 	movabs $0x803020,%rdx
  800138:	00 00 00 
  80013b:	be 15 00 00 00       	mov    $0x15,%esi
  800140:	48 bf 71 31 80 00 00 	movabs $0x803171,%rdi
  800147:	00 00 00 
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	49 b8 35 02 80 00 00 	movabs $0x800235,%r8
  800156:	00 00 00 
  800159:	41 ff d0             	call   *%r8

000000000080015c <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80015c:	f3 0f 1e fa          	endbr64
  800160:	55                   	push   %rbp
  800161:	48 89 e5             	mov    %rsp,%rbp
  800164:	41 56                	push   %r14
  800166:	41 55                	push   %r13
  800168:	41 54                	push   %r12
  80016a:	53                   	push   %rbx
  80016b:	41 89 fd             	mov    %edi,%r13d
  80016e:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800171:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800178:	00 00 00 
  80017b:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800182:	00 00 00 
  800185:	48 39 c2             	cmp    %rax,%rdx
  800188:	73 17                	jae    8001a1 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80018a:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80018d:	49 89 c4             	mov    %rax,%r12
  800190:	48 83 c3 08          	add    $0x8,%rbx
  800194:	b8 00 00 00 00       	mov    $0x0,%eax
  800199:	ff 53 f8             	call   *-0x8(%rbx)
  80019c:	4c 39 e3             	cmp    %r12,%rbx
  80019f:	72 ef                	jb     800190 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8001a1:	48 b8 0f 12 80 00 00 	movabs $0x80120f,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	call   *%rax
  8001ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001b6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001ba:	48 c1 e0 04          	shl    $0x4,%rax
  8001be:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001c5:	00 00 00 
  8001c8:	48 01 d0             	add    %rdx,%rax
  8001cb:	48 a3 00 50 c0 00 00 	movabs %rax,0xc05000
  8001d2:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001d5:	45 85 ed             	test   %r13d,%r13d
  8001d8:	7e 0d                	jle    8001e7 <libmain+0x8b>
  8001da:	49 8b 06             	mov    (%r14),%rax
  8001dd:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8001e4:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001e7:	4c 89 f6             	mov    %r14,%rsi
  8001ea:	44 89 ef             	mov    %r13d,%edi
  8001ed:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001f4:	00 00 00 
  8001f7:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001f9:	48 b8 0e 02 80 00 00 	movabs $0x80020e,%rax
  800200:	00 00 00 
  800203:	ff d0                	call   *%rax
#endif
}
  800205:	5b                   	pop    %rbx
  800206:	41 5c                	pop    %r12
  800208:	41 5d                	pop    %r13
  80020a:	41 5e                	pop    %r14
  80020c:	5d                   	pop    %rbp
  80020d:	c3                   	ret

000000000080020e <exit>:

#include <inc/lib.h>

void
exit(void) {
  80020e:	f3 0f 1e fa          	endbr64
  800212:	55                   	push   %rbp
  800213:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800216:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  80021d:	00 00 00 
  800220:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800222:	bf 00 00 00 00       	mov    $0x0,%edi
  800227:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  80022e:	00 00 00 
  800231:	ff d0                	call   *%rax
}
  800233:	5d                   	pop    %rbp
  800234:	c3                   	ret

0000000000800235 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800235:	f3 0f 1e fa          	endbr64
  800239:	55                   	push   %rbp
  80023a:	48 89 e5             	mov    %rsp,%rbp
  80023d:	41 56                	push   %r14
  80023f:	41 55                	push   %r13
  800241:	41 54                	push   %r12
  800243:	53                   	push   %rbx
  800244:	48 83 ec 50          	sub    $0x50,%rsp
  800248:	49 89 fc             	mov    %rdi,%r12
  80024b:	41 89 f5             	mov    %esi,%r13d
  80024e:	48 89 d3             	mov    %rdx,%rbx
  800251:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800255:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800259:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80025d:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800264:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800268:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80026c:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800270:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800274:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80027b:	00 00 00 
  80027e:	4c 8b 30             	mov    (%rax),%r14
  800281:	48 b8 0f 12 80 00 00 	movabs $0x80120f,%rax
  800288:	00 00 00 
  80028b:	ff d0                	call   *%rax
  80028d:	89 c6                	mov    %eax,%esi
  80028f:	45 89 e8             	mov    %r13d,%r8d
  800292:	4c 89 e1             	mov    %r12,%rcx
  800295:	4c 89 f2             	mov    %r14,%rdx
  800298:	48 bf 80 30 80 00 00 	movabs $0x803080,%rdi
  80029f:	00 00 00 
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a7:	49 bc 91 03 80 00 00 	movabs $0x800391,%r12
  8002ae:	00 00 00 
  8002b1:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002b4:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002b8:	48 89 df             	mov    %rbx,%rdi
  8002bb:	48 b8 29 03 80 00 00 	movabs $0x800329,%rax
  8002c2:	00 00 00 
  8002c5:	ff d0                	call   *%rax
    cprintf("\n");
  8002c7:	48 bf 6f 31 80 00 00 	movabs $0x80316f,%rdi
  8002ce:	00 00 00 
  8002d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d6:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002d9:	cc                   	int3
  8002da:	eb fd                	jmp    8002d9 <_panic+0xa4>

00000000008002dc <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002dc:	f3 0f 1e fa          	endbr64
  8002e0:	55                   	push   %rbp
  8002e1:	48 89 e5             	mov    %rsp,%rbp
  8002e4:	53                   	push   %rbx
  8002e5:	48 83 ec 08          	sub    $0x8,%rsp
  8002e9:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002ec:	8b 06                	mov    (%rsi),%eax
  8002ee:	8d 50 01             	lea    0x1(%rax),%edx
  8002f1:	89 16                	mov    %edx,(%rsi)
  8002f3:	48 98                	cltq
  8002f5:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002fa:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800300:	74 0a                	je     80030c <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800302:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800306:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80030a:	c9                   	leave
  80030b:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80030c:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800310:	be ff 00 00 00       	mov    $0xff,%esi
  800315:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	call   *%rax
        state->offset = 0;
  800321:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800327:	eb d9                	jmp    800302 <putch+0x26>

0000000000800329 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800329:	f3 0f 1e fa          	endbr64
  80032d:	55                   	push   %rbp
  80032e:	48 89 e5             	mov    %rsp,%rbp
  800331:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800338:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80033b:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800342:	b9 21 00 00 00       	mov    $0x21,%ecx
  800347:	b8 00 00 00 00       	mov    $0x0,%eax
  80034c:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80034f:	48 89 f1             	mov    %rsi,%rcx
  800352:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800359:	48 bf dc 02 80 00 00 	movabs $0x8002dc,%rdi
  800360:	00 00 00 
  800363:	48 b8 f1 04 80 00 00 	movabs $0x8004f1,%rax
  80036a:	00 00 00 
  80036d:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80036f:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800376:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80037d:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  800384:	00 00 00 
  800387:	ff d0                	call   *%rax

    return state.count;
}
  800389:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80038f:	c9                   	leave
  800390:	c3                   	ret

0000000000800391 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800391:	f3 0f 1e fa          	endbr64
  800395:	55                   	push   %rbp
  800396:	48 89 e5             	mov    %rsp,%rbp
  800399:	48 83 ec 50          	sub    $0x50,%rsp
  80039d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003a1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003a5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003a9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003ad:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8003b1:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8003b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003c0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003c4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003c8:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8003cc:	48 b8 29 03 80 00 00 	movabs $0x800329,%rax
  8003d3:	00 00 00 
  8003d6:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8003d8:	c9                   	leave
  8003d9:	c3                   	ret

00000000008003da <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8003da:	f3 0f 1e fa          	endbr64
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	41 57                	push   %r15
  8003e4:	41 56                	push   %r14
  8003e6:	41 55                	push   %r13
  8003e8:	41 54                	push   %r12
  8003ea:	53                   	push   %rbx
  8003eb:	48 83 ec 18          	sub    $0x18,%rsp
  8003ef:	49 89 fc             	mov    %rdi,%r12
  8003f2:	49 89 f5             	mov    %rsi,%r13
  8003f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003f9:	8b 45 10             	mov    0x10(%rbp),%eax
  8003fc:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003ff:	41 89 cf             	mov    %ecx,%r15d
  800402:	4c 39 fa             	cmp    %r15,%rdx
  800405:	73 5b                	jae    800462 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800407:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80040b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80040f:	85 db                	test   %ebx,%ebx
  800411:	7e 0e                	jle    800421 <print_num+0x47>
            putch(padc, put_arg);
  800413:	4c 89 ee             	mov    %r13,%rsi
  800416:	44 89 f7             	mov    %r14d,%edi
  800419:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80041c:	83 eb 01             	sub    $0x1,%ebx
  80041f:	75 f2                	jne    800413 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800421:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800425:	48 b9 b2 31 80 00 00 	movabs $0x8031b2,%rcx
  80042c:	00 00 00 
  80042f:	48 b8 a1 31 80 00 00 	movabs $0x8031a1,%rax
  800436:	00 00 00 
  800439:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80043d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	49 f7 f7             	div    %r15
  800449:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80044d:	4c 89 ee             	mov    %r13,%rsi
  800450:	41 ff d4             	call   *%r12
}
  800453:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800457:	5b                   	pop    %rbx
  800458:	41 5c                	pop    %r12
  80045a:	41 5d                	pop    %r13
  80045c:	41 5e                	pop    %r14
  80045e:	41 5f                	pop    %r15
  800460:	5d                   	pop    %rbp
  800461:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800462:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800466:	ba 00 00 00 00       	mov    $0x0,%edx
  80046b:	49 f7 f7             	div    %r15
  80046e:	48 83 ec 08          	sub    $0x8,%rsp
  800472:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800476:	52                   	push   %rdx
  800477:	45 0f be c9          	movsbl %r9b,%r9d
  80047b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80047f:	48 89 c2             	mov    %rax,%rdx
  800482:	48 b8 da 03 80 00 00 	movabs $0x8003da,%rax
  800489:	00 00 00 
  80048c:	ff d0                	call   *%rax
  80048e:	48 83 c4 10          	add    $0x10,%rsp
  800492:	eb 8d                	jmp    800421 <print_num+0x47>

0000000000800494 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800494:	f3 0f 1e fa          	endbr64
    state->count++;
  800498:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80049c:	48 8b 06             	mov    (%rsi),%rax
  80049f:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004a3:	73 0a                	jae    8004af <sprintputch+0x1b>
        *state->start++ = ch;
  8004a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004a9:	48 89 16             	mov    %rdx,(%rsi)
  8004ac:	40 88 38             	mov    %dil,(%rax)
    }
}
  8004af:	c3                   	ret

00000000008004b0 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8004b0:	f3 0f 1e fa          	endbr64
  8004b4:	55                   	push   %rbp
  8004b5:	48 89 e5             	mov    %rsp,%rbp
  8004b8:	48 83 ec 50          	sub    $0x50,%rsp
  8004bc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004c0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004c4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004c8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004db:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8004df:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8004e3:	48 b8 f1 04 80 00 00 	movabs $0x8004f1,%rax
  8004ea:	00 00 00 
  8004ed:	ff d0                	call   *%rax
}
  8004ef:	c9                   	leave
  8004f0:	c3                   	ret

00000000008004f1 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004f1:	f3 0f 1e fa          	endbr64
  8004f5:	55                   	push   %rbp
  8004f6:	48 89 e5             	mov    %rsp,%rbp
  8004f9:	41 57                	push   %r15
  8004fb:	41 56                	push   %r14
  8004fd:	41 55                	push   %r13
  8004ff:	41 54                	push   %r12
  800501:	53                   	push   %rbx
  800502:	48 83 ec 38          	sub    $0x38,%rsp
  800506:	49 89 fe             	mov    %rdi,%r14
  800509:	49 89 f5             	mov    %rsi,%r13
  80050c:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80050f:	48 8b 01             	mov    (%rcx),%rax
  800512:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800516:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80051a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80051e:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800522:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800526:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80052a:	0f b6 3b             	movzbl (%rbx),%edi
  80052d:	40 80 ff 25          	cmp    $0x25,%dil
  800531:	74 18                	je     80054b <vprintfmt+0x5a>
            if (!ch) return;
  800533:	40 84 ff             	test   %dil,%dil
  800536:	0f 84 b2 06 00 00    	je     800bee <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80053c:	40 0f b6 ff          	movzbl %dil,%edi
  800540:	4c 89 ee             	mov    %r13,%rsi
  800543:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800546:	4c 89 e3             	mov    %r12,%rbx
  800549:	eb db                	jmp    800526 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80054b:	be 00 00 00 00       	mov    $0x0,%esi
  800550:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800554:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800559:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80055f:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800566:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80056a:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80056f:	41 0f b6 04 24       	movzbl (%r12),%eax
  800574:	88 45 a0             	mov    %al,-0x60(%rbp)
  800577:	83 e8 23             	sub    $0x23,%eax
  80057a:	3c 57                	cmp    $0x57,%al
  80057c:	0f 87 52 06 00 00    	ja     800bd4 <vprintfmt+0x6e3>
  800582:	0f b6 c0             	movzbl %al,%eax
  800585:	48 b9 00 34 80 00 00 	movabs $0x803400,%rcx
  80058c:	00 00 00 
  80058f:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800593:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800596:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80059a:	eb ce                	jmp    80056a <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80059c:	49 89 dc             	mov    %rbx,%r12
  80059f:	be 01 00 00 00       	mov    $0x1,%esi
  8005a4:	eb c4                	jmp    80056a <vprintfmt+0x79>
            padc = ch;
  8005a6:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8005aa:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005ad:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005b0:	eb b8                	jmp    80056a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8005b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005b5:	83 f8 2f             	cmp    $0x2f,%eax
  8005b8:	77 24                	ja     8005de <vprintfmt+0xed>
  8005ba:	89 c1                	mov    %eax,%ecx
  8005bc:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8005c0:	83 c0 08             	add    $0x8,%eax
  8005c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005c6:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8005c9:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8005cc:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005d0:	79 98                	jns    80056a <vprintfmt+0x79>
                width = precision;
  8005d2:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8005d6:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005dc:	eb 8c                	jmp    80056a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8005de:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8005e2:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8005e6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005ea:	eb da                	jmp    8005c6 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8005ec:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8005f1:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005f5:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8005fb:	3c 39                	cmp    $0x39,%al
  8005fd:	77 1c                	ja     80061b <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8005ff:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800603:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800607:	0f b6 c0             	movzbl %al,%eax
  80060a:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80060f:	0f b6 03             	movzbl (%rbx),%eax
  800612:	3c 39                	cmp    $0x39,%al
  800614:	76 e9                	jbe    8005ff <vprintfmt+0x10e>
        process_precision:
  800616:	49 89 dc             	mov    %rbx,%r12
  800619:	eb b1                	jmp    8005cc <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80061b:	49 89 dc             	mov    %rbx,%r12
  80061e:	eb ac                	jmp    8005cc <vprintfmt+0xdb>
            width = MAX(0, width);
  800620:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800623:	85 c9                	test   %ecx,%ecx
  800625:	b8 00 00 00 00       	mov    $0x0,%eax
  80062a:	0f 49 c1             	cmovns %ecx,%eax
  80062d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800630:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800633:	e9 32 ff ff ff       	jmp    80056a <vprintfmt+0x79>
            lflag++;
  800638:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80063b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80063e:	e9 27 ff ff ff       	jmp    80056a <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800643:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800646:	83 f8 2f             	cmp    $0x2f,%eax
  800649:	77 19                	ja     800664 <vprintfmt+0x173>
  80064b:	89 c2                	mov    %eax,%edx
  80064d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800651:	83 c0 08             	add    $0x8,%eax
  800654:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800657:	8b 3a                	mov    (%rdx),%edi
  800659:	4c 89 ee             	mov    %r13,%rsi
  80065c:	41 ff d6             	call   *%r14
            break;
  80065f:	e9 c2 fe ff ff       	jmp    800526 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800664:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800668:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80066c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800670:	eb e5                	jmp    800657 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800672:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800675:	83 f8 2f             	cmp    $0x2f,%eax
  800678:	77 5a                	ja     8006d4 <vprintfmt+0x1e3>
  80067a:	89 c2                	mov    %eax,%edx
  80067c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800680:	83 c0 08             	add    $0x8,%eax
  800683:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800686:	8b 02                	mov    (%rdx),%eax
  800688:	89 c1                	mov    %eax,%ecx
  80068a:	f7 d9                	neg    %ecx
  80068c:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80068f:	83 f9 13             	cmp    $0x13,%ecx
  800692:	7f 4e                	jg     8006e2 <vprintfmt+0x1f1>
  800694:	48 63 c1             	movslq %ecx,%rax
  800697:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  80069e:	00 00 00 
  8006a1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006a5:	48 85 c0             	test   %rax,%rax
  8006a8:	74 38                	je     8006e2 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba a6 33 80 00 00 	movabs $0x8033a6,%rdx
  8006b4:	00 00 00 
  8006b7:	4c 89 ee             	mov    %r13,%rsi
  8006ba:	4c 89 f7             	mov    %r14,%rdi
  8006bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c2:	49 b8 b0 04 80 00 00 	movabs $0x8004b0,%r8
  8006c9:	00 00 00 
  8006cc:	41 ff d0             	call   *%r8
  8006cf:	e9 52 fe ff ff       	jmp    800526 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8006d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e0:	eb a4                	jmp    800686 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8006e2:	48 ba ca 31 80 00 00 	movabs $0x8031ca,%rdx
  8006e9:	00 00 00 
  8006ec:	4c 89 ee             	mov    %r13,%rsi
  8006ef:	4c 89 f7             	mov    %r14,%rdi
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f7:	49 b8 b0 04 80 00 00 	movabs $0x8004b0,%r8
  8006fe:	00 00 00 
  800701:	41 ff d0             	call   *%r8
  800704:	e9 1d fe ff ff       	jmp    800526 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800709:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070c:	83 f8 2f             	cmp    $0x2f,%eax
  80070f:	77 6c                	ja     80077d <vprintfmt+0x28c>
  800711:	89 c2                	mov    %eax,%edx
  800713:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800717:	83 c0 08             	add    $0x8,%eax
  80071a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80071d:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800720:	48 85 d2             	test   %rdx,%rdx
  800723:	48 b8 c3 31 80 00 00 	movabs $0x8031c3,%rax
  80072a:	00 00 00 
  80072d:	48 0f 45 c2          	cmovne %rdx,%rax
  800731:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800735:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800739:	7e 06                	jle    800741 <vprintfmt+0x250>
  80073b:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80073f:	75 4a                	jne    80078b <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800741:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800745:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800749:	0f b6 00             	movzbl (%rax),%eax
  80074c:	84 c0                	test   %al,%al
  80074e:	0f 85 9a 00 00 00    	jne    8007ee <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800754:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800757:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80075b:	85 c0                	test   %eax,%eax
  80075d:	0f 8e c3 fd ff ff    	jle    800526 <vprintfmt+0x35>
  800763:	4c 89 ee             	mov    %r13,%rsi
  800766:	bf 20 00 00 00       	mov    $0x20,%edi
  80076b:	41 ff d6             	call   *%r14
  80076e:	41 83 ec 01          	sub    $0x1,%r12d
  800772:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800776:	75 eb                	jne    800763 <vprintfmt+0x272>
  800778:	e9 a9 fd ff ff       	jmp    800526 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80077d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800781:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800785:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800789:	eb 92                	jmp    80071d <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80078b:	49 63 f7             	movslq %r15d,%rsi
  80078e:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800792:	48 b8 b4 0c 80 00 00 	movabs $0x800cb4,%rax
  800799:	00 00 00 
  80079c:	ff d0                	call   *%rax
  80079e:	48 89 c2             	mov    %rax,%rdx
  8007a1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007a4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007a6:	8d 70 ff             	lea    -0x1(%rax),%esi
  8007a9:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	7e 91                	jle    800741 <vprintfmt+0x250>
  8007b0:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8007b5:	4c 89 ee             	mov    %r13,%rsi
  8007b8:	44 89 e7             	mov    %r12d,%edi
  8007bb:	41 ff d6             	call   *%r14
  8007be:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8007c2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007c5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8007c8:	75 eb                	jne    8007b5 <vprintfmt+0x2c4>
  8007ca:	e9 72 ff ff ff       	jmp    800741 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007cf:	0f b6 f8             	movzbl %al,%edi
  8007d2:	4c 89 ee             	mov    %r13,%rsi
  8007d5:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007d8:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8007dc:	49 83 c4 01          	add    $0x1,%r12
  8007e0:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8007e6:	84 c0                	test   %al,%al
  8007e8:	0f 84 66 ff ff ff    	je     800754 <vprintfmt+0x263>
  8007ee:	45 85 ff             	test   %r15d,%r15d
  8007f1:	78 0a                	js     8007fd <vprintfmt+0x30c>
  8007f3:	41 83 ef 01          	sub    $0x1,%r15d
  8007f7:	0f 88 57 ff ff ff    	js     800754 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007fd:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800801:	74 cc                	je     8007cf <vprintfmt+0x2de>
  800803:	8d 50 e0             	lea    -0x20(%rax),%edx
  800806:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80080b:	80 fa 5e             	cmp    $0x5e,%dl
  80080e:	77 c2                	ja     8007d2 <vprintfmt+0x2e1>
  800810:	eb bd                	jmp    8007cf <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800812:	40 84 f6             	test   %sil,%sil
  800815:	75 26                	jne    80083d <vprintfmt+0x34c>
    switch (lflag) {
  800817:	85 d2                	test   %edx,%edx
  800819:	74 59                	je     800874 <vprintfmt+0x383>
  80081b:	83 fa 01             	cmp    $0x1,%edx
  80081e:	74 7b                	je     80089b <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800820:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800823:	83 f8 2f             	cmp    $0x2f,%eax
  800826:	0f 87 96 00 00 00    	ja     8008c2 <vprintfmt+0x3d1>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800832:	83 c0 08             	add    $0x8,%eax
  800835:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800838:	4c 8b 22             	mov    (%rdx),%r12
  80083b:	eb 17                	jmp    800854 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80083d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800840:	83 f8 2f             	cmp    $0x2f,%eax
  800843:	77 21                	ja     800866 <vprintfmt+0x375>
  800845:	89 c2                	mov    %eax,%edx
  800847:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80084b:	83 c0 08             	add    $0x8,%eax
  80084e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800851:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800854:	4d 85 e4             	test   %r12,%r12
  800857:	78 7a                	js     8008d3 <vprintfmt+0x3e2>
            num = i;
  800859:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80085c:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800861:	e9 50 02 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800866:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80086e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800872:	eb dd                	jmp    800851 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	83 f8 2f             	cmp    $0x2f,%eax
  80087a:	77 11                	ja     80088d <vprintfmt+0x39c>
  80087c:	89 c2                	mov    %eax,%edx
  80087e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800882:	83 c0 08             	add    $0x8,%eax
  800885:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800888:	4c 63 22             	movslq (%rdx),%r12
  80088b:	eb c7                	jmp    800854 <vprintfmt+0x363>
  80088d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800891:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800895:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800899:	eb ed                	jmp    800888 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80089b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089e:	83 f8 2f             	cmp    $0x2f,%eax
  8008a1:	77 11                	ja     8008b4 <vprintfmt+0x3c3>
  8008a3:	89 c2                	mov    %eax,%edx
  8008a5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a9:	83 c0 08             	add    $0x8,%eax
  8008ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008af:	4c 8b 22             	mov    (%rdx),%r12
  8008b2:	eb a0                	jmp    800854 <vprintfmt+0x363>
  8008b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c0:	eb ed                	jmp    8008af <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8008c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ce:	e9 65 ff ff ff       	jmp    800838 <vprintfmt+0x347>
                putch('-', put_arg);
  8008d3:	4c 89 ee             	mov    %r13,%rsi
  8008d6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8008db:	41 ff d6             	call   *%r14
                i = -i;
  8008de:	49 f7 dc             	neg    %r12
  8008e1:	e9 73 ff ff ff       	jmp    800859 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8008e6:	40 84 f6             	test   %sil,%sil
  8008e9:	75 32                	jne    80091d <vprintfmt+0x42c>
    switch (lflag) {
  8008eb:	85 d2                	test   %edx,%edx
  8008ed:	74 5d                	je     80094c <vprintfmt+0x45b>
  8008ef:	83 fa 01             	cmp    $0x1,%edx
  8008f2:	0f 84 82 00 00 00    	je     80097a <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8008f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fb:	83 f8 2f             	cmp    $0x2f,%eax
  8008fe:	0f 87 a5 00 00 00    	ja     8009a9 <vprintfmt+0x4b8>
  800904:	89 c2                	mov    %eax,%edx
  800906:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80090a:	83 c0 08             	add    $0x8,%eax
  80090d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800910:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800913:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800918:	e9 99 01 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80091d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800920:	83 f8 2f             	cmp    $0x2f,%eax
  800923:	77 19                	ja     80093e <vprintfmt+0x44d>
  800925:	89 c2                	mov    %eax,%edx
  800927:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80092b:	83 c0 08             	add    $0x8,%eax
  80092e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800931:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800934:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800939:	e9 78 01 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
  80093e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800942:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800946:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094a:	eb e5                	jmp    800931 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80094c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094f:	83 f8 2f             	cmp    $0x2f,%eax
  800952:	77 18                	ja     80096c <vprintfmt+0x47b>
  800954:	89 c2                	mov    %eax,%edx
  800956:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80095a:	83 c0 08             	add    $0x8,%eax
  80095d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800960:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800962:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800967:	e9 4a 01 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
  80096c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800970:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800974:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800978:	eb e6                	jmp    800960 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  80097a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097d:	83 f8 2f             	cmp    $0x2f,%eax
  800980:	77 19                	ja     80099b <vprintfmt+0x4aa>
  800982:	89 c2                	mov    %eax,%edx
  800984:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800988:	83 c0 08             	add    $0x8,%eax
  80098b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800991:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800996:	e9 1b 01 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
  80099b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a7:	eb e5                	jmp    80098e <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8009a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ad:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b5:	e9 56 ff ff ff       	jmp    800910 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8009ba:	40 84 f6             	test   %sil,%sil
  8009bd:	75 2e                	jne    8009ed <vprintfmt+0x4fc>
    switch (lflag) {
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	74 59                	je     800a1c <vprintfmt+0x52b>
  8009c3:	83 fa 01             	cmp    $0x1,%edx
  8009c6:	74 7f                	je     800a47 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8009c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cb:	83 f8 2f             	cmp    $0x2f,%eax
  8009ce:	0f 87 9f 00 00 00    	ja     800a73 <vprintfmt+0x582>
  8009d4:	89 c2                	mov    %eax,%edx
  8009d6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009da:	83 c0 08             	add    $0x8,%eax
  8009dd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009e3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009e8:	e9 c9 00 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f0:	83 f8 2f             	cmp    $0x2f,%eax
  8009f3:	77 19                	ja     800a0e <vprintfmt+0x51d>
  8009f5:	89 c2                	mov    %eax,%edx
  8009f7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009fb:	83 c0 08             	add    $0x8,%eax
  8009fe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a01:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a04:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a09:	e9 a8 00 00 00       	jmp    800ab6 <vprintfmt+0x5c5>
  800a0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a12:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1a:	eb e5                	jmp    800a01 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800a1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1f:	83 f8 2f             	cmp    $0x2f,%eax
  800a22:	77 15                	ja     800a39 <vprintfmt+0x548>
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a30:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800a32:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a37:	eb 7d                	jmp    800ab6 <vprintfmt+0x5c5>
  800a39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a45:	eb e9                	jmp    800a30 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4a:	83 f8 2f             	cmp    $0x2f,%eax
  800a4d:	77 16                	ja     800a65 <vprintfmt+0x574>
  800a4f:	89 c2                	mov    %eax,%edx
  800a51:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a5b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a5e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a63:	eb 51                	jmp    800ab6 <vprintfmt+0x5c5>
  800a65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a69:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a71:	eb e8                	jmp    800a5b <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800a73:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a77:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7f:	e9 5c ff ff ff       	jmp    8009e0 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800a84:	4c 89 ee             	mov    %r13,%rsi
  800a87:	bf 30 00 00 00       	mov    $0x30,%edi
  800a8c:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800a8f:	4c 89 ee             	mov    %r13,%rsi
  800a92:	bf 78 00 00 00       	mov    $0x78,%edi
  800a97:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9d:	83 f8 2f             	cmp    $0x2f,%eax
  800aa0:	77 47                	ja     800ae9 <vprintfmt+0x5f8>
  800aa2:	89 c2                	mov    %eax,%edx
  800aa4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa8:	83 c0 08             	add    $0x8,%eax
  800aab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aae:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ab1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800ab6:	48 83 ec 08          	sub    $0x8,%rsp
  800aba:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800abe:	0f 94 c0             	sete   %al
  800ac1:	0f b6 c0             	movzbl %al,%eax
  800ac4:	50                   	push   %rax
  800ac5:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800aca:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800ace:	4c 89 ee             	mov    %r13,%rsi
  800ad1:	4c 89 f7             	mov    %r14,%rdi
  800ad4:	48 b8 da 03 80 00 00 	movabs $0x8003da,%rax
  800adb:	00 00 00 
  800ade:	ff d0                	call   *%rax
            break;
  800ae0:	48 83 c4 10          	add    $0x10,%rsp
  800ae4:	e9 3d fa ff ff       	jmp    800526 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800ae9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af5:	eb b7                	jmp    800aae <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800af7:	40 84 f6             	test   %sil,%sil
  800afa:	75 2b                	jne    800b27 <vprintfmt+0x636>
    switch (lflag) {
  800afc:	85 d2                	test   %edx,%edx
  800afe:	74 56                	je     800b56 <vprintfmt+0x665>
  800b00:	83 fa 01             	cmp    $0x1,%edx
  800b03:	74 7f                	je     800b84 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b08:	83 f8 2f             	cmp    $0x2f,%eax
  800b0b:	0f 87 a2 00 00 00    	ja     800bb3 <vprintfmt+0x6c2>
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b17:	83 c0 08             	add    $0x8,%eax
  800b1a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b1d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b20:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b25:	eb 8f                	jmp    800ab6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2a:	83 f8 2f             	cmp    $0x2f,%eax
  800b2d:	77 19                	ja     800b48 <vprintfmt+0x657>
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b35:	83 c0 08             	add    $0x8,%eax
  800b38:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b3b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b3e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b43:	e9 6e ff ff ff       	jmp    800ab6 <vprintfmt+0x5c5>
  800b48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b4c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b50:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b54:	eb e5                	jmp    800b3b <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800b56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b59:	83 f8 2f             	cmp    $0x2f,%eax
  800b5c:	77 18                	ja     800b76 <vprintfmt+0x685>
  800b5e:	89 c2                	mov    %eax,%edx
  800b60:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b64:	83 c0 08             	add    $0x8,%eax
  800b67:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b6a:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800b6c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b71:	e9 40 ff ff ff       	jmp    800ab6 <vprintfmt+0x5c5>
  800b76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b82:	eb e6                	jmp    800b6a <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800b84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b87:	83 f8 2f             	cmp    $0x2f,%eax
  800b8a:	77 19                	ja     800ba5 <vprintfmt+0x6b4>
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b92:	83 c0 08             	add    $0x8,%eax
  800b95:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b98:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b9b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800ba0:	e9 11 ff ff ff       	jmp    800ab6 <vprintfmt+0x5c5>
  800ba5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb1:	eb e5                	jmp    800b98 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800bb3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bbb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bbf:	e9 59 ff ff ff       	jmp    800b1d <vprintfmt+0x62c>
            putch(ch, put_arg);
  800bc4:	4c 89 ee             	mov    %r13,%rsi
  800bc7:	bf 25 00 00 00       	mov    $0x25,%edi
  800bcc:	41 ff d6             	call   *%r14
            break;
  800bcf:	e9 52 f9 ff ff       	jmp    800526 <vprintfmt+0x35>
            putch('%', put_arg);
  800bd4:	4c 89 ee             	mov    %r13,%rsi
  800bd7:	bf 25 00 00 00       	mov    $0x25,%edi
  800bdc:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800bdf:	48 83 eb 01          	sub    $0x1,%rbx
  800be3:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800be7:	75 f6                	jne    800bdf <vprintfmt+0x6ee>
  800be9:	e9 38 f9 ff ff       	jmp    800526 <vprintfmt+0x35>
}
  800bee:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800bf2:	5b                   	pop    %rbx
  800bf3:	41 5c                	pop    %r12
  800bf5:	41 5d                	pop    %r13
  800bf7:	41 5e                	pop    %r14
  800bf9:	41 5f                	pop    %r15
  800bfb:	5d                   	pop    %rbp
  800bfc:	c3                   	ret

0000000000800bfd <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bfd:	f3 0f 1e fa          	endbr64
  800c01:	55                   	push   %rbp
  800c02:	48 89 e5             	mov    %rsp,%rbp
  800c05:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c0d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c16:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c1d:	48 85 ff             	test   %rdi,%rdi
  800c20:	74 2b                	je     800c4d <vsnprintf+0x50>
  800c22:	48 85 f6             	test   %rsi,%rsi
  800c25:	74 26                	je     800c4d <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c27:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c2b:	48 bf 94 04 80 00 00 	movabs $0x800494,%rdi
  800c32:	00 00 00 
  800c35:	48 b8 f1 04 80 00 00 	movabs $0x8004f1,%rax
  800c3c:	00 00 00 
  800c3f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c48:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c4b:	c9                   	leave
  800c4c:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800c4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c52:	eb f7                	jmp    800c4b <vsnprintf+0x4e>

0000000000800c54 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c54:	f3 0f 1e fa          	endbr64
  800c58:	55                   	push   %rbp
  800c59:	48 89 e5             	mov    %rsp,%rbp
  800c5c:	48 83 ec 50          	sub    $0x50,%rsp
  800c60:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c64:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c68:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c6c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c73:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c7b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c7f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c83:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c87:	48 b8 fd 0b 80 00 00 	movabs $0x800bfd,%rax
  800c8e:	00 00 00 
  800c91:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c93:	c9                   	leave
  800c94:	c3                   	ret

0000000000800c95 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800c95:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c99:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c9c:	74 10                	je     800cae <strlen+0x19>
    size_t n = 0;
  800c9e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ca3:	48 83 c0 01          	add    $0x1,%rax
  800ca7:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cab:	75 f6                	jne    800ca3 <strlen+0xe>
  800cad:	c3                   	ret
    size_t n = 0;
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800cb3:	c3                   	ret

0000000000800cb4 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800cb4:	f3 0f 1e fa          	endbr64
  800cb8:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800cc0:	48 85 f6             	test   %rsi,%rsi
  800cc3:	74 10                	je     800cd5 <strnlen+0x21>
  800cc5:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800cc9:	74 0b                	je     800cd6 <strnlen+0x22>
  800ccb:	48 83 c2 01          	add    $0x1,%rdx
  800ccf:	48 39 d0             	cmp    %rdx,%rax
  800cd2:	75 f1                	jne    800cc5 <strnlen+0x11>
  800cd4:	c3                   	ret
  800cd5:	c3                   	ret
  800cd6:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800cd9:	c3                   	ret

0000000000800cda <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800cda:	f3 0f 1e fa          	endbr64
  800cde:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800cea:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800ced:	48 83 c2 01          	add    $0x1,%rdx
  800cf1:	84 c9                	test   %cl,%cl
  800cf3:	75 f1                	jne    800ce6 <strcpy+0xc>
        ;
    return res;
}
  800cf5:	c3                   	ret

0000000000800cf6 <strcat>:

char *
strcat(char *dst, const char *src) {
  800cf6:	f3 0f 1e fa          	endbr64
  800cfa:	55                   	push   %rbp
  800cfb:	48 89 e5             	mov    %rsp,%rbp
  800cfe:	41 54                	push   %r12
  800d00:	53                   	push   %rbx
  800d01:	48 89 fb             	mov    %rdi,%rbx
  800d04:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d07:	48 b8 95 0c 80 00 00 	movabs $0x800c95,%rax
  800d0e:	00 00 00 
  800d11:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d13:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d17:	4c 89 e6             	mov    %r12,%rsi
  800d1a:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  800d21:	00 00 00 
  800d24:	ff d0                	call   *%rax
    return dst;
}
  800d26:	48 89 d8             	mov    %rbx,%rax
  800d29:	5b                   	pop    %rbx
  800d2a:	41 5c                	pop    %r12
  800d2c:	5d                   	pop    %rbp
  800d2d:	c3                   	ret

0000000000800d2e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d2e:	f3 0f 1e fa          	endbr64
  800d32:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800d35:	48 85 d2             	test   %rdx,%rdx
  800d38:	74 1f                	je     800d59 <strncpy+0x2b>
  800d3a:	48 01 fa             	add    %rdi,%rdx
  800d3d:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800d40:	48 83 c1 01          	add    $0x1,%rcx
  800d44:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d48:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d4c:	41 80 f8 01          	cmp    $0x1,%r8b
  800d50:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d54:	48 39 ca             	cmp    %rcx,%rdx
  800d57:	75 e7                	jne    800d40 <strncpy+0x12>
    }
    return ret;
}
  800d59:	c3                   	ret

0000000000800d5a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800d5a:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800d5e:	48 89 f8             	mov    %rdi,%rax
  800d61:	48 85 d2             	test   %rdx,%rdx
  800d64:	74 24                	je     800d8a <strlcpy+0x30>
        while (--size > 0 && *src)
  800d66:	48 83 ea 01          	sub    $0x1,%rdx
  800d6a:	74 1b                	je     800d87 <strlcpy+0x2d>
  800d6c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d70:	0f b6 16             	movzbl (%rsi),%edx
  800d73:	84 d2                	test   %dl,%dl
  800d75:	74 10                	je     800d87 <strlcpy+0x2d>
            *dst++ = *src++;
  800d77:	48 83 c6 01          	add    $0x1,%rsi
  800d7b:	48 83 c0 01          	add    $0x1,%rax
  800d7f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d82:	48 39 c8             	cmp    %rcx,%rax
  800d85:	75 e9                	jne    800d70 <strlcpy+0x16>
        *dst = '\0';
  800d87:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d8a:	48 29 f8             	sub    %rdi,%rax
}
  800d8d:	c3                   	ret

0000000000800d8e <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800d8e:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800d92:	0f b6 07             	movzbl (%rdi),%eax
  800d95:	84 c0                	test   %al,%al
  800d97:	74 13                	je     800dac <strcmp+0x1e>
  800d99:	38 06                	cmp    %al,(%rsi)
  800d9b:	75 0f                	jne    800dac <strcmp+0x1e>
  800d9d:	48 83 c7 01          	add    $0x1,%rdi
  800da1:	48 83 c6 01          	add    $0x1,%rsi
  800da5:	0f b6 07             	movzbl (%rdi),%eax
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ed                	jne    800d99 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800dac:	0f b6 c0             	movzbl %al,%eax
  800daf:	0f b6 16             	movzbl (%rsi),%edx
  800db2:	29 d0                	sub    %edx,%eax
}
  800db4:	c3                   	ret

0000000000800db5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800db5:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800db9:	48 85 d2             	test   %rdx,%rdx
  800dbc:	74 1f                	je     800ddd <strncmp+0x28>
  800dbe:	0f b6 07             	movzbl (%rdi),%eax
  800dc1:	84 c0                	test   %al,%al
  800dc3:	74 1e                	je     800de3 <strncmp+0x2e>
  800dc5:	3a 06                	cmp    (%rsi),%al
  800dc7:	75 1a                	jne    800de3 <strncmp+0x2e>
  800dc9:	48 83 c7 01          	add    $0x1,%rdi
  800dcd:	48 83 c6 01          	add    $0x1,%rsi
  800dd1:	48 83 ea 01          	sub    $0x1,%rdx
  800dd5:	75 e7                	jne    800dbe <strncmp+0x9>

    if (!n) return 0;
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddc:	c3                   	ret
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
  800de2:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800de3:	0f b6 07             	movzbl (%rdi),%eax
  800de6:	0f b6 16             	movzbl (%rsi),%edx
  800de9:	29 d0                	sub    %edx,%eax
}
  800deb:	c3                   	ret

0000000000800dec <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800dec:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800df0:	0f b6 17             	movzbl (%rdi),%edx
  800df3:	84 d2                	test   %dl,%dl
  800df5:	74 18                	je     800e0f <strchr+0x23>
        if (*str == c) {
  800df7:	0f be d2             	movsbl %dl,%edx
  800dfa:	39 f2                	cmp    %esi,%edx
  800dfc:	74 17                	je     800e15 <strchr+0x29>
    for (; *str; str++) {
  800dfe:	48 83 c7 01          	add    $0x1,%rdi
  800e02:	0f b6 17             	movzbl (%rdi),%edx
  800e05:	84 d2                	test   %dl,%dl
  800e07:	75 ee                	jne    800df7 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e09:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0e:	c3                   	ret
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	c3                   	ret
            return (char *)str;
  800e15:	48 89 f8             	mov    %rdi,%rax
}
  800e18:	c3                   	ret

0000000000800e19 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800e19:	f3 0f 1e fa          	endbr64
  800e1d:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800e20:	0f b6 17             	movzbl (%rdi),%edx
  800e23:	84 d2                	test   %dl,%dl
  800e25:	74 13                	je     800e3a <strfind+0x21>
  800e27:	0f be d2             	movsbl %dl,%edx
  800e2a:	39 f2                	cmp    %esi,%edx
  800e2c:	74 0b                	je     800e39 <strfind+0x20>
  800e2e:	48 83 c0 01          	add    $0x1,%rax
  800e32:	0f b6 10             	movzbl (%rax),%edx
  800e35:	84 d2                	test   %dl,%dl
  800e37:	75 ee                	jne    800e27 <strfind+0xe>
        ;
    return (char *)str;
}
  800e39:	c3                   	ret
  800e3a:	c3                   	ret

0000000000800e3b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e3b:	f3 0f 1e fa          	endbr64
  800e3f:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e42:	48 89 f8             	mov    %rdi,%rax
  800e45:	48 f7 d8             	neg    %rax
  800e48:	83 e0 07             	and    $0x7,%eax
  800e4b:	49 89 d1             	mov    %rdx,%r9
  800e4e:	49 29 c1             	sub    %rax,%r9
  800e51:	78 36                	js     800e89 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e53:	40 0f b6 c6          	movzbl %sil,%eax
  800e57:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800e5e:	01 01 01 
  800e61:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e65:	40 f6 c7 07          	test   $0x7,%dil
  800e69:	75 38                	jne    800ea3 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e6b:	4c 89 c9             	mov    %r9,%rcx
  800e6e:	48 c1 f9 03          	sar    $0x3,%rcx
  800e72:	74 0c                	je     800e80 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e74:	fc                   	cld
  800e75:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e78:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800e7c:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e80:	4d 85 c9             	test   %r9,%r9
  800e83:	75 45                	jne    800eca <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e85:	4c 89 c0             	mov    %r8,%rax
  800e88:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800e89:	48 85 d2             	test   %rdx,%rdx
  800e8c:	74 f7                	je     800e85 <memset+0x4a>
  800e8e:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e91:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e94:	48 83 c0 01          	add    $0x1,%rax
  800e98:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e9c:	48 39 c2             	cmp    %rax,%rdx
  800e9f:	75 f3                	jne    800e94 <memset+0x59>
  800ea1:	eb e2                	jmp    800e85 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ea3:	40 f6 c7 01          	test   $0x1,%dil
  800ea7:	74 06                	je     800eaf <memset+0x74>
  800ea9:	88 07                	mov    %al,(%rdi)
  800eab:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800eaf:	40 f6 c7 02          	test   $0x2,%dil
  800eb3:	74 07                	je     800ebc <memset+0x81>
  800eb5:	66 89 07             	mov    %ax,(%rdi)
  800eb8:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ebc:	40 f6 c7 04          	test   $0x4,%dil
  800ec0:	74 a9                	je     800e6b <memset+0x30>
  800ec2:	89 07                	mov    %eax,(%rdi)
  800ec4:	48 83 c7 04          	add    $0x4,%rdi
  800ec8:	eb a1                	jmp    800e6b <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800eca:	41 f6 c1 04          	test   $0x4,%r9b
  800ece:	74 1b                	je     800eeb <memset+0xb0>
  800ed0:	89 07                	mov    %eax,(%rdi)
  800ed2:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ed6:	41 f6 c1 02          	test   $0x2,%r9b
  800eda:	74 07                	je     800ee3 <memset+0xa8>
  800edc:	66 89 07             	mov    %ax,(%rdi)
  800edf:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800ee3:	41 f6 c1 01          	test   $0x1,%r9b
  800ee7:	74 9c                	je     800e85 <memset+0x4a>
  800ee9:	eb 06                	jmp    800ef1 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800eeb:	41 f6 c1 02          	test   $0x2,%r9b
  800eef:	75 eb                	jne    800edc <memset+0xa1>
        if (ni & 1) *ptr = k;
  800ef1:	88 07                	mov    %al,(%rdi)
  800ef3:	eb 90                	jmp    800e85 <memset+0x4a>

0000000000800ef5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ef5:	f3 0f 1e fa          	endbr64
  800ef9:	48 89 f8             	mov    %rdi,%rax
  800efc:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800eff:	48 39 fe             	cmp    %rdi,%rsi
  800f02:	73 3b                	jae    800f3f <memmove+0x4a>
  800f04:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f08:	48 39 d7             	cmp    %rdx,%rdi
  800f0b:	73 32                	jae    800f3f <memmove+0x4a>
        s += n;
        d += n;
  800f0d:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f11:	48 89 d6             	mov    %rdx,%rsi
  800f14:	48 09 fe             	or     %rdi,%rsi
  800f17:	48 09 ce             	or     %rcx,%rsi
  800f1a:	40 f6 c6 07          	test   $0x7,%sil
  800f1e:	75 12                	jne    800f32 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f20:	48 83 ef 08          	sub    $0x8,%rdi
  800f24:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f28:	48 c1 e9 03          	shr    $0x3,%rcx
  800f2c:	fd                   	std
  800f2d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f30:	fc                   	cld
  800f31:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f32:	48 83 ef 01          	sub    $0x1,%rdi
  800f36:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f3a:	fd                   	std
  800f3b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f3d:	eb f1                	jmp    800f30 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f3f:	48 89 f2             	mov    %rsi,%rdx
  800f42:	48 09 c2             	or     %rax,%rdx
  800f45:	48 09 ca             	or     %rcx,%rdx
  800f48:	f6 c2 07             	test   $0x7,%dl
  800f4b:	75 0c                	jne    800f59 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f4d:	48 c1 e9 03          	shr    $0x3,%rcx
  800f51:	48 89 c7             	mov    %rax,%rdi
  800f54:	fc                   	cld
  800f55:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f58:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f59:	48 89 c7             	mov    %rax,%rdi
  800f5c:	fc                   	cld
  800f5d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f5f:	c3                   	ret

0000000000800f60 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f60:	f3 0f 1e fa          	endbr64
  800f64:	55                   	push   %rbp
  800f65:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f68:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	call   *%rax
}
  800f74:	5d                   	pop    %rbp
  800f75:	c3                   	ret

0000000000800f76 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f76:	f3 0f 1e fa          	endbr64
  800f7a:	55                   	push   %rbp
  800f7b:	48 89 e5             	mov    %rsp,%rbp
  800f7e:	41 57                	push   %r15
  800f80:	41 56                	push   %r14
  800f82:	41 55                	push   %r13
  800f84:	41 54                	push   %r12
  800f86:	53                   	push   %rbx
  800f87:	48 83 ec 08          	sub    $0x8,%rsp
  800f8b:	49 89 fe             	mov    %rdi,%r14
  800f8e:	49 89 f7             	mov    %rsi,%r15
  800f91:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f94:	48 89 f7             	mov    %rsi,%rdi
  800f97:	48 b8 95 0c 80 00 00 	movabs $0x800c95,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	call   *%rax
  800fa3:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800fa6:	48 89 de             	mov    %rbx,%rsi
  800fa9:	4c 89 f7             	mov    %r14,%rdi
  800fac:	48 b8 b4 0c 80 00 00 	movabs $0x800cb4,%rax
  800fb3:	00 00 00 
  800fb6:	ff d0                	call   *%rax
  800fb8:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800fbb:	48 39 c3             	cmp    %rax,%rbx
  800fbe:	74 36                	je     800ff6 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800fc0:	48 89 d8             	mov    %rbx,%rax
  800fc3:	4c 29 e8             	sub    %r13,%rax
  800fc6:	49 39 c4             	cmp    %rax,%r12
  800fc9:	73 31                	jae    800ffc <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800fcb:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800fd0:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fd4:	4c 89 fe             	mov    %r15,%rsi
  800fd7:	48 b8 60 0f 80 00 00 	movabs $0x800f60,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	call   *%rax
    return dstlen + srclen;
  800fe3:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800fe7:	48 83 c4 08          	add    $0x8,%rsp
  800feb:	5b                   	pop    %rbx
  800fec:	41 5c                	pop    %r12
  800fee:	41 5d                	pop    %r13
  800ff0:	41 5e                	pop    %r14
  800ff2:	41 5f                	pop    %r15
  800ff4:	5d                   	pop    %rbp
  800ff5:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800ff6:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800ffa:	eb eb                	jmp    800fe7 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ffc:	48 83 eb 01          	sub    $0x1,%rbx
  801000:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801004:	48 89 da             	mov    %rbx,%rdx
  801007:	4c 89 fe             	mov    %r15,%rsi
  80100a:	48 b8 60 0f 80 00 00 	movabs $0x800f60,%rax
  801011:	00 00 00 
  801014:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801016:	49 01 de             	add    %rbx,%r14
  801019:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80101e:	eb c3                	jmp    800fe3 <strlcat+0x6d>

0000000000801020 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801020:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801024:	48 85 d2             	test   %rdx,%rdx
  801027:	74 2d                	je     801056 <memcmp+0x36>
  801029:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80102e:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801032:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801037:	44 38 c1             	cmp    %r8b,%cl
  80103a:	75 0f                	jne    80104b <memcmp+0x2b>
    while (n-- > 0) {
  80103c:	48 83 c0 01          	add    $0x1,%rax
  801040:	48 39 c2             	cmp    %rax,%rdx
  801043:	75 e9                	jne    80102e <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
  80104a:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80104b:	0f b6 c1             	movzbl %cl,%eax
  80104e:	45 0f b6 c0          	movzbl %r8b,%r8d
  801052:	44 29 c0             	sub    %r8d,%eax
  801055:	c3                   	ret
    return 0;
  801056:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105b:	c3                   	ret

000000000080105c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80105c:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801060:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801064:	48 39 c7             	cmp    %rax,%rdi
  801067:	73 0f                	jae    801078 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801069:	40 38 37             	cmp    %sil,(%rdi)
  80106c:	74 0e                	je     80107c <memfind+0x20>
    for (; src < end; src++) {
  80106e:	48 83 c7 01          	add    $0x1,%rdi
  801072:	48 39 f8             	cmp    %rdi,%rax
  801075:	75 f2                	jne    801069 <memfind+0xd>
  801077:	c3                   	ret
  801078:	48 89 f8             	mov    %rdi,%rax
  80107b:	c3                   	ret
  80107c:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80107f:	c3                   	ret

0000000000801080 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801080:	f3 0f 1e fa          	endbr64
  801084:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801087:	0f b6 37             	movzbl (%rdi),%esi
  80108a:	40 80 fe 20          	cmp    $0x20,%sil
  80108e:	74 06                	je     801096 <strtol+0x16>
  801090:	40 80 fe 09          	cmp    $0x9,%sil
  801094:	75 13                	jne    8010a9 <strtol+0x29>
  801096:	48 83 c7 01          	add    $0x1,%rdi
  80109a:	0f b6 37             	movzbl (%rdi),%esi
  80109d:	40 80 fe 20          	cmp    $0x20,%sil
  8010a1:	74 f3                	je     801096 <strtol+0x16>
  8010a3:	40 80 fe 09          	cmp    $0x9,%sil
  8010a7:	74 ed                	je     801096 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010a9:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8010ac:	83 e0 fd             	and    $0xfffffffd,%eax
  8010af:	3c 01                	cmp    $0x1,%al
  8010b1:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010b5:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8010bb:	75 0f                	jne    8010cc <strtol+0x4c>
  8010bd:	80 3f 30             	cmpb   $0x30,(%rdi)
  8010c0:	74 14                	je     8010d6 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8010c2:	85 d2                	test   %edx,%edx
  8010c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010c9:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8010cc:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8010d1:	4c 63 ca             	movslq %edx,%r9
  8010d4:	eb 36                	jmp    80110c <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010d6:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8010da:	74 0f                	je     8010eb <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8010dc:	85 d2                	test   %edx,%edx
  8010de:	75 ec                	jne    8010cc <strtol+0x4c>
        s++;
  8010e0:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8010e4:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8010e9:	eb e1                	jmp    8010cc <strtol+0x4c>
        s += 2;
  8010eb:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010ef:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8010f4:	eb d6                	jmp    8010cc <strtol+0x4c>
            dig -= '0';
  8010f6:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8010f9:	44 0f b6 c1          	movzbl %cl,%r8d
  8010fd:	41 39 d0             	cmp    %edx,%r8d
  801100:	7d 21                	jge    801123 <strtol+0xa3>
        val = val * base + dig;
  801102:	49 0f af c1          	imul   %r9,%rax
  801106:	0f b6 c9             	movzbl %cl,%ecx
  801109:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80110c:	48 83 c7 01          	add    $0x1,%rdi
  801110:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801114:	80 f9 39             	cmp    $0x39,%cl
  801117:	76 dd                	jbe    8010f6 <strtol+0x76>
        else if (dig - 'a' < 27)
  801119:	80 f9 7b             	cmp    $0x7b,%cl
  80111c:	77 05                	ja     801123 <strtol+0xa3>
            dig -= 'a' - 10;
  80111e:	83 e9 57             	sub    $0x57,%ecx
  801121:	eb d6                	jmp    8010f9 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801123:	4d 85 d2             	test   %r10,%r10
  801126:	74 03                	je     80112b <strtol+0xab>
  801128:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80112b:	48 89 c2             	mov    %rax,%rdx
  80112e:	48 f7 da             	neg    %rdx
  801131:	40 80 fe 2d          	cmp    $0x2d,%sil
  801135:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801139:	c3                   	ret

000000000080113a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80113a:	f3 0f 1e fa          	endbr64
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	53                   	push   %rbx
  801143:	48 89 fa             	mov    %rdi,%rdx
  801146:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80114e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801153:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801158:	be 00 00 00 00       	mov    $0x0,%esi
  80115d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801163:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801165:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801169:	c9                   	leave
  80116a:	c3                   	ret

000000000080116b <sys_cgetc>:

int
sys_cgetc(void) {
  80116b:	f3 0f 1e fa          	endbr64
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801174:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801179:	ba 00 00 00 00       	mov    $0x0,%edx
  80117e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801183:	bb 00 00 00 00       	mov    $0x0,%ebx
  801188:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80118d:	be 00 00 00 00       	mov    $0x0,%esi
  801192:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801198:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80119a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80119e:	c9                   	leave
  80119f:	c3                   	ret

00000000008011a0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8011a0:	f3 0f 1e fa          	endbr64
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	53                   	push   %rbx
  8011a9:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8011ad:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011b0:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011c4:	be 00 00 00 00       	mov    $0x0,%esi
  8011c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011cf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011d1:	48 85 c0             	test   %rax,%rax
  8011d4:	7f 06                	jg     8011dc <sys_env_destroy+0x3c>
}
  8011d6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011da:	c9                   	leave
  8011db:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011dc:	49 89 c0             	mov    %rax,%r8
  8011df:	b9 03 00 00 00       	mov    $0x3,%ecx
  8011e4:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  8011eb:	00 00 00 
  8011ee:	be 26 00 00 00       	mov    $0x26,%esi
  8011f3:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  8011fa:	00 00 00 
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801202:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  801209:	00 00 00 
  80120c:	41 ff d1             	call   *%r9

000000000080120f <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80120f:	f3 0f 1e fa          	endbr64
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801218:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80121d:	ba 00 00 00 00       	mov    $0x0,%edx
  801222:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801227:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801231:	be 00 00 00 00       	mov    $0x0,%esi
  801236:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80123c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80123e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801242:	c9                   	leave
  801243:	c3                   	ret

0000000000801244 <sys_yield>:

void
sys_yield(void) {
  801244:	f3 0f 1e fa          	endbr64
  801248:	55                   	push   %rbp
  801249:	48 89 e5             	mov    %rsp,%rbp
  80124c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80124d:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801252:	ba 00 00 00 00       	mov    $0x0,%edx
  801257:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80125c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801261:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801266:	be 00 00 00 00       	mov    $0x0,%esi
  80126b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801271:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801273:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801277:	c9                   	leave
  801278:	c3                   	ret

0000000000801279 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801279:	f3 0f 1e fa          	endbr64
  80127d:	55                   	push   %rbp
  80127e:	48 89 e5             	mov    %rsp,%rbp
  801281:	53                   	push   %rbx
  801282:	48 89 fa             	mov    %rdi,%rdx
  801285:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801288:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80128d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801294:	00 00 00 
  801297:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80129c:	be 00 00 00 00       	mov    $0x0,%esi
  8012a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012a7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ad:	c9                   	leave
  8012ae:	c3                   	ret

00000000008012af <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8012af:	f3 0f 1e fa          	endbr64
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	53                   	push   %rbx
  8012b8:	49 89 f8             	mov    %rdi,%r8
  8012bb:	48 89 d3             	mov    %rdx,%rbx
  8012be:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8012c1:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012c6:	4c 89 c2             	mov    %r8,%rdx
  8012c9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012cc:	be 00 00 00 00       	mov    $0x0,%esi
  8012d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012d7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8012d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012dd:	c9                   	leave
  8012de:	c3                   	ret

00000000008012df <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8012df:	f3 0f 1e fa          	endbr64
  8012e3:	55                   	push   %rbp
  8012e4:	48 89 e5             	mov    %rsp,%rbp
  8012e7:	53                   	push   %rbx
  8012e8:	48 83 ec 08          	sub    $0x8,%rsp
  8012ec:	89 f8                	mov    %edi,%eax
  8012ee:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012f1:	48 63 f9             	movslq %ecx,%rdi
  8012f4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f7:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fc:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ff:	be 00 00 00 00       	mov    $0x0,%esi
  801304:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80130c:	48 85 c0             	test   %rax,%rax
  80130f:	7f 06                	jg     801317 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801311:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801315:	c9                   	leave
  801316:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801317:	49 89 c0             	mov    %rax,%r8
  80131a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80131f:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  801326:	00 00 00 
  801329:	be 26 00 00 00       	mov    $0x26,%esi
  80132e:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  801335:	00 00 00 
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  801344:	00 00 00 
  801347:	41 ff d1             	call   *%r9

000000000080134a <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80134a:	f3 0f 1e fa          	endbr64
  80134e:	55                   	push   %rbp
  80134f:	48 89 e5             	mov    %rsp,%rbp
  801352:	53                   	push   %rbx
  801353:	48 83 ec 08          	sub    $0x8,%rsp
  801357:	89 f8                	mov    %edi,%eax
  801359:	49 89 f2             	mov    %rsi,%r10
  80135c:	48 89 cf             	mov    %rcx,%rdi
  80135f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801362:	48 63 da             	movslq %edx,%rbx
  801365:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801368:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80136d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801370:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801373:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801375:	48 85 c0             	test   %rax,%rax
  801378:	7f 06                	jg     801380 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80137a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137e:	c9                   	leave
  80137f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801380:	49 89 c0             	mov    %rax,%r8
  801383:	b9 05 00 00 00       	mov    $0x5,%ecx
  801388:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  80138f:	00 00 00 
  801392:	be 26 00 00 00       	mov    $0x26,%esi
  801397:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  80139e:	00 00 00 
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a6:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  8013ad:	00 00 00 
  8013b0:	41 ff d1             	call   *%r9

00000000008013b3 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013b3:	f3 0f 1e fa          	endbr64
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	53                   	push   %rbx
  8013bc:	48 83 ec 08          	sub    $0x8,%rsp
  8013c0:	49 89 f9             	mov    %rdi,%r9
  8013c3:	89 f0                	mov    %esi,%eax
  8013c5:	48 89 d3             	mov    %rdx,%rbx
  8013c8:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8013cb:	49 63 f0             	movslq %r8d,%rsi
  8013ce:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013d1:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d6:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013df:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013e1:	48 85 c0             	test   %rax,%rax
  8013e4:	7f 06                	jg     8013ec <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013e6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ea:	c9                   	leave
  8013eb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ec:	49 89 c0             	mov    %rax,%r8
  8013ef:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013f4:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  8013fb:	00 00 00 
  8013fe:	be 26 00 00 00       	mov    $0x26,%esi
  801403:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  80140a:	00 00 00 
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  801419:	00 00 00 
  80141c:	41 ff d1             	call   *%r9

000000000080141f <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80141f:	f3 0f 1e fa          	endbr64
  801423:	55                   	push   %rbp
  801424:	48 89 e5             	mov    %rsp,%rbp
  801427:	53                   	push   %rbx
  801428:	48 83 ec 08          	sub    $0x8,%rsp
  80142c:	48 89 f1             	mov    %rsi,%rcx
  80142f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801432:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801435:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80143a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143f:	be 00 00 00 00       	mov    $0x0,%esi
  801444:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80144a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80144c:	48 85 c0             	test   %rax,%rax
  80144f:	7f 06                	jg     801457 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801451:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801455:	c9                   	leave
  801456:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801457:	49 89 c0             	mov    %rax,%r8
  80145a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80145f:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  801466:	00 00 00 
  801469:	be 26 00 00 00       	mov    $0x26,%esi
  80146e:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  801475:	00 00 00 
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
  80147d:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  801484:	00 00 00 
  801487:	41 ff d1             	call   *%r9

000000000080148a <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80148a:	f3 0f 1e fa          	endbr64
  80148e:	55                   	push   %rbp
  80148f:	48 89 e5             	mov    %rsp,%rbp
  801492:	53                   	push   %rbx
  801493:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801497:	48 63 ce             	movslq %esi,%rcx
  80149a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80149d:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ac:	be 00 00 00 00       	mov    $0x0,%esi
  8014b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	7f 06                	jg     8014c4 <sys_env_set_status+0x3a>
}
  8014be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c2:	c9                   	leave
  8014c3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c4:	49 89 c0             	mov    %rax,%r8
  8014c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014cc:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  8014d3:	00 00 00 
  8014d6:	be 26 00 00 00       	mov    $0x26,%esi
  8014db:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  8014e2:	00 00 00 
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  8014f1:	00 00 00 
  8014f4:	41 ff d1             	call   *%r9

00000000008014f7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8014f7:	f3 0f 1e fa          	endbr64
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	53                   	push   %rbx
  801500:	48 83 ec 08          	sub    $0x8,%rsp
  801504:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801507:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80150a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80150f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801514:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801519:	be 00 00 00 00       	mov    $0x0,%esi
  80151e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801524:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801526:	48 85 c0             	test   %rax,%rax
  801529:	7f 06                	jg     801531 <sys_env_set_trapframe+0x3a>
}
  80152b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80152f:	c9                   	leave
  801530:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801531:	49 89 c0             	mov    %rax,%r8
  801534:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801539:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  801540:	00 00 00 
  801543:	be 26 00 00 00       	mov    $0x26,%esi
  801548:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  80154f:	00 00 00 
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  80155e:	00 00 00 
  801561:	41 ff d1             	call   *%r9

0000000000801564 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801564:	f3 0f 1e fa          	endbr64
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	53                   	push   %rbx
  80156d:	48 83 ec 08          	sub    $0x8,%rsp
  801571:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801574:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801577:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80157c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801581:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801586:	be 00 00 00 00       	mov    $0x0,%esi
  80158b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801591:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801593:	48 85 c0             	test   %rax,%rax
  801596:	7f 06                	jg     80159e <sys_env_set_pgfault_upcall+0x3a>
}
  801598:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80159c:	c9                   	leave
  80159d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80159e:	49 89 c0             	mov    %rax,%r8
  8015a1:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8015a6:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  8015ad:	00 00 00 
  8015b0:	be 26 00 00 00       	mov    $0x26,%esi
  8015b5:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  8015bc:	00 00 00 
  8015bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c4:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  8015cb:	00 00 00 
  8015ce:	41 ff d1             	call   *%r9

00000000008015d1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8015d1:	f3 0f 1e fa          	endbr64
  8015d5:	55                   	push   %rbp
  8015d6:	48 89 e5             	mov    %rsp,%rbp
  8015d9:	53                   	push   %rbx
  8015da:	89 f8                	mov    %edi,%eax
  8015dc:	49 89 f1             	mov    %rsi,%r9
  8015df:	48 89 d3             	mov    %rdx,%rbx
  8015e2:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8015e5:	49 63 f0             	movslq %r8d,%rsi
  8015e8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015eb:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015f0:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015f9:	cd 30                	int    $0x30
}
  8015fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ff:	c9                   	leave
  801600:	c3                   	ret

0000000000801601 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801601:	f3 0f 1e fa          	endbr64
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	53                   	push   %rbx
  80160a:	48 83 ec 08          	sub    $0x8,%rsp
  80160e:	48 89 fa             	mov    %rdi,%rdx
  801611:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801614:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801619:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801623:	be 00 00 00 00       	mov    $0x0,%esi
  801628:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80162e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801630:	48 85 c0             	test   %rax,%rax
  801633:	7f 06                	jg     80163b <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801635:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801639:	c9                   	leave
  80163a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80163b:	49 89 c0             	mov    %rax,%r8
  80163e:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801643:	48 ba c8 30 80 00 00 	movabs $0x8030c8,%rdx
  80164a:	00 00 00 
  80164d:	be 26 00 00 00       	mov    $0x26,%esi
  801652:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  801659:	00 00 00 
  80165c:	b8 00 00 00 00       	mov    $0x0,%eax
  801661:	49 b9 35 02 80 00 00 	movabs $0x800235,%r9
  801668:	00 00 00 
  80166b:	41 ff d1             	call   *%r9

000000000080166e <sys_gettime>:

int
sys_gettime(void) {
  80166e:	f3 0f 1e fa          	endbr64
  801672:	55                   	push   %rbp
  801673:	48 89 e5             	mov    %rsp,%rbp
  801676:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801677:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801686:	bb 00 00 00 00       	mov    $0x0,%ebx
  80168b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801690:	be 00 00 00 00       	mov    $0x0,%esi
  801695:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80169b:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80169d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016a1:	c9                   	leave
  8016a2:	c3                   	ret

00000000008016a3 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8016a3:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016a7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016ae:	ff ff ff 
  8016b1:	48 01 f8             	add    %rdi,%rax
  8016b4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8016b8:	c3                   	ret

00000000008016b9 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8016b9:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016bd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016c4:	ff ff ff 
  8016c7:	48 01 f8             	add    %rdi,%rax
  8016ca:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8016ce:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8016d4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8016d8:	c3                   	ret

00000000008016d9 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8016d9:	f3 0f 1e fa          	endbr64
  8016dd:	55                   	push   %rbp
  8016de:	48 89 e5             	mov    %rsp,%rbp
  8016e1:	41 57                	push   %r15
  8016e3:	41 56                	push   %r14
  8016e5:	41 55                	push   %r13
  8016e7:	41 54                	push   %r12
  8016e9:	53                   	push   %rbx
  8016ea:	48 83 ec 08          	sub    $0x8,%rsp
  8016ee:	49 89 ff             	mov    %rdi,%r15
  8016f1:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8016f6:	49 bd 38 28 80 00 00 	movabs $0x802838,%r13
  8016fd:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801700:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801706:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801709:	48 89 df             	mov    %rbx,%rdi
  80170c:	41 ff d5             	call   *%r13
  80170f:	83 e0 04             	and    $0x4,%eax
  801712:	74 17                	je     80172b <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801714:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80171b:	4c 39 f3             	cmp    %r14,%rbx
  80171e:	75 e6                	jne    801706 <fd_alloc+0x2d>
  801720:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801726:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80172b:	4d 89 27             	mov    %r12,(%r15)
}
  80172e:	48 83 c4 08          	add    $0x8,%rsp
  801732:	5b                   	pop    %rbx
  801733:	41 5c                	pop    %r12
  801735:	41 5d                	pop    %r13
  801737:	41 5e                	pop    %r14
  801739:	41 5f                	pop    %r15
  80173b:	5d                   	pop    %rbp
  80173c:	c3                   	ret

000000000080173d <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80173d:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801741:	83 ff 1f             	cmp    $0x1f,%edi
  801744:	77 39                	ja     80177f <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801746:	55                   	push   %rbp
  801747:	48 89 e5             	mov    %rsp,%rbp
  80174a:	41 54                	push   %r12
  80174c:	53                   	push   %rbx
  80174d:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801750:	48 63 df             	movslq %edi,%rbx
  801753:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80175a:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80175e:	48 89 df             	mov    %rbx,%rdi
  801761:	48 b8 38 28 80 00 00 	movabs $0x802838,%rax
  801768:	00 00 00 
  80176b:	ff d0                	call   *%rax
  80176d:	a8 04                	test   $0x4,%al
  80176f:	74 14                	je     801785 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801771:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177a:	5b                   	pop    %rbx
  80177b:	41 5c                	pop    %r12
  80177d:	5d                   	pop    %rbp
  80177e:	c3                   	ret
        return -E_INVAL;
  80177f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801784:	c3                   	ret
        return -E_INVAL;
  801785:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178a:	eb ee                	jmp    80177a <fd_lookup+0x3d>

000000000080178c <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80178c:	f3 0f 1e fa          	endbr64
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	41 54                	push   %r12
  801796:	53                   	push   %rbx
  801797:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80179a:	48 b8 60 37 80 00 00 	movabs $0x803760,%rax
  8017a1:	00 00 00 
  8017a4:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  8017ab:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8017ae:	39 3b                	cmp    %edi,(%rbx)
  8017b0:	74 47                	je     8017f9 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8017b2:	48 83 c0 08          	add    $0x8,%rax
  8017b6:	48 8b 18             	mov    (%rax),%rbx
  8017b9:	48 85 db             	test   %rbx,%rbx
  8017bc:	75 f0                	jne    8017ae <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017be:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  8017c5:	00 00 00 
  8017c8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8017ce:	89 fa                	mov    %edi,%edx
  8017d0:	48 bf e8 30 80 00 00 	movabs $0x8030e8,%rdi
  8017d7:	00 00 00 
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	48 b9 91 03 80 00 00 	movabs $0x800391,%rcx
  8017e6:	00 00 00 
  8017e9:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8017eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8017f0:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8017f4:	5b                   	pop    %rbx
  8017f5:	41 5c                	pop    %r12
  8017f7:	5d                   	pop    %rbp
  8017f8:	c3                   	ret
            return 0;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	eb f0                	jmp    8017f0 <dev_lookup+0x64>

0000000000801800 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801800:	f3 0f 1e fa          	endbr64
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	41 55                	push   %r13
  80180a:	41 54                	push   %r12
  80180c:	53                   	push   %rbx
  80180d:	48 83 ec 18          	sub    $0x18,%rsp
  801811:	48 89 fb             	mov    %rdi,%rbx
  801814:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801817:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80181e:	ff ff ff 
  801821:	48 01 df             	add    %rbx,%rdi
  801824:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801828:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80182c:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801833:	00 00 00 
  801836:	ff d0                	call   *%rax
  801838:	41 89 c5             	mov    %eax,%r13d
  80183b:	85 c0                	test   %eax,%eax
  80183d:	78 06                	js     801845 <fd_close+0x45>
  80183f:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801843:	74 1a                	je     80185f <fd_close+0x5f>
        return (must_exist ? res : 0);
  801845:	45 84 e4             	test   %r12b,%r12b
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
  80184d:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801851:	44 89 e8             	mov    %r13d,%eax
  801854:	48 83 c4 18          	add    $0x18,%rsp
  801858:	5b                   	pop    %rbx
  801859:	41 5c                	pop    %r12
  80185b:	41 5d                	pop    %r13
  80185d:	5d                   	pop    %rbp
  80185e:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80185f:	8b 3b                	mov    (%rbx),%edi
  801861:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801865:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  80186c:	00 00 00 
  80186f:	ff d0                	call   *%rax
  801871:	41 89 c5             	mov    %eax,%r13d
  801874:	85 c0                	test   %eax,%eax
  801876:	78 1b                	js     801893 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801878:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801880:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801886:	48 85 c0             	test   %rax,%rax
  801889:	74 08                	je     801893 <fd_close+0x93>
  80188b:	48 89 df             	mov    %rbx,%rdi
  80188e:	ff d0                	call   *%rax
  801890:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801893:	ba 00 10 00 00       	mov    $0x1000,%edx
  801898:	48 89 de             	mov    %rbx,%rsi
  80189b:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a0:	48 b8 1f 14 80 00 00 	movabs $0x80141f,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	call   *%rax
    return res;
  8018ac:	eb a3                	jmp    801851 <fd_close+0x51>

00000000008018ae <close>:

int
close(int fdnum) {
  8018ae:	f3 0f 1e fa          	endbr64
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8018ba:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018be:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	78 15                	js     8018e3 <close+0x35>

    return fd_close(fd, 1);
  8018ce:	be 01 00 00 00       	mov    $0x1,%esi
  8018d3:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8018d7:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  8018de:	00 00 00 
  8018e1:	ff d0                	call   *%rax
}
  8018e3:	c9                   	leave
  8018e4:	c3                   	ret

00000000008018e5 <close_all>:

void
close_all(void) {
  8018e5:	f3 0f 1e fa          	endbr64
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	41 54                	push   %r12
  8018ef:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8018f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f5:	49 bc ae 18 80 00 00 	movabs $0x8018ae,%r12
  8018fc:	00 00 00 
  8018ff:	89 df                	mov    %ebx,%edi
  801901:	41 ff d4             	call   *%r12
  801904:	83 c3 01             	add    $0x1,%ebx
  801907:	83 fb 20             	cmp    $0x20,%ebx
  80190a:	75 f3                	jne    8018ff <close_all+0x1a>
}
  80190c:	5b                   	pop    %rbx
  80190d:	41 5c                	pop    %r12
  80190f:	5d                   	pop    %rbp
  801910:	c3                   	ret

0000000000801911 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801911:	f3 0f 1e fa          	endbr64
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	41 57                	push   %r15
  80191b:	41 56                	push   %r14
  80191d:	41 55                	push   %r13
  80191f:	41 54                	push   %r12
  801921:	53                   	push   %rbx
  801922:	48 83 ec 18          	sub    $0x18,%rsp
  801926:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801929:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80192d:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801934:	00 00 00 
  801937:	ff d0                	call   *%rax
  801939:	89 c3                	mov    %eax,%ebx
  80193b:	85 c0                	test   %eax,%eax
  80193d:	0f 88 b8 00 00 00    	js     8019fb <dup+0xea>
    close(newfdnum);
  801943:	44 89 e7             	mov    %r12d,%edi
  801946:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  80194d:	00 00 00 
  801950:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801952:	4d 63 ec             	movslq %r12d,%r13
  801955:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80195c:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801960:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801964:	4c 89 ff             	mov    %r15,%rdi
  801967:	49 be b9 16 80 00 00 	movabs $0x8016b9,%r14
  80196e:	00 00 00 
  801971:	41 ff d6             	call   *%r14
  801974:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801977:	4c 89 ef             	mov    %r13,%rdi
  80197a:	41 ff d6             	call   *%r14
  80197d:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801980:	48 89 df             	mov    %rbx,%rdi
  801983:	48 b8 38 28 80 00 00 	movabs $0x802838,%rax
  80198a:	00 00 00 
  80198d:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80198f:	a8 04                	test   $0x4,%al
  801991:	74 2b                	je     8019be <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801993:	41 89 c1             	mov    %eax,%r9d
  801996:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80199c:	4c 89 f1             	mov    %r14,%rcx
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	48 89 de             	mov    %rbx,%rsi
  8019a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ac:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  8019b3:	00 00 00 
  8019b6:	ff d0                	call   *%rax
  8019b8:	89 c3                	mov    %eax,%ebx
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 4e                	js     801a0c <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8019be:	4c 89 ff             	mov    %r15,%rdi
  8019c1:	48 b8 38 28 80 00 00 	movabs $0x802838,%rax
  8019c8:	00 00 00 
  8019cb:	ff d0                	call   *%rax
  8019cd:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8019d0:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019d6:	4c 89 e9             	mov    %r13,%rcx
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	4c 89 fe             	mov    %r15,%rsi
  8019e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8019e6:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  8019ed:	00 00 00 
  8019f0:	ff d0                	call   *%rax
  8019f2:	89 c3                	mov    %eax,%ebx
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 14                	js     801a0c <dup+0xfb>

    return newfdnum;
  8019f8:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8019fb:	89 d8                	mov    %ebx,%eax
  8019fd:	48 83 c4 18          	add    $0x18,%rsp
  801a01:	5b                   	pop    %rbx
  801a02:	41 5c                	pop    %r12
  801a04:	41 5d                	pop    %r13
  801a06:	41 5e                	pop    %r14
  801a08:	41 5f                	pop    %r15
  801a0a:	5d                   	pop    %rbp
  801a0b:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a0c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a11:	4c 89 ee             	mov    %r13,%rsi
  801a14:	bf 00 00 00 00       	mov    $0x0,%edi
  801a19:	49 bc 1f 14 80 00 00 	movabs $0x80141f,%r12
  801a20:	00 00 00 
  801a23:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a26:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a2b:	4c 89 f6             	mov    %r14,%rsi
  801a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a33:	41 ff d4             	call   *%r12
    return res;
  801a36:	eb c3                	jmp    8019fb <dup+0xea>

0000000000801a38 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801a38:	f3 0f 1e fa          	endbr64
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	41 56                	push   %r14
  801a42:	41 55                	push   %r13
  801a44:	41 54                	push   %r12
  801a46:	53                   	push   %rbx
  801a47:	48 83 ec 10          	sub    $0x10,%rsp
  801a4b:	89 fb                	mov    %edi,%ebx
  801a4d:	49 89 f4             	mov    %rsi,%r12
  801a50:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a53:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a57:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	call   *%rax
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 4c                	js     801ab3 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a67:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801a6b:	41 8b 3e             	mov    (%r14),%edi
  801a6e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a72:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  801a79:	00 00 00 
  801a7c:	ff d0                	call   *%rax
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 35                	js     801ab7 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a82:	41 8b 46 08          	mov    0x8(%r14),%eax
  801a86:	83 e0 03             	and    $0x3,%eax
  801a89:	83 f8 01             	cmp    $0x1,%eax
  801a8c:	74 2d                	je     801abb <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a92:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a96:	48 85 c0             	test   %rax,%rax
  801a99:	74 56                	je     801af1 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801a9b:	4c 89 ea             	mov    %r13,%rdx
  801a9e:	4c 89 e6             	mov    %r12,%rsi
  801aa1:	4c 89 f7             	mov    %r14,%rdi
  801aa4:	ff d0                	call   *%rax
}
  801aa6:	48 83 c4 10          	add    $0x10,%rsp
  801aaa:	5b                   	pop    %rbx
  801aab:	41 5c                	pop    %r12
  801aad:	41 5d                	pop    %r13
  801aaf:	41 5e                	pop    %r14
  801ab1:	5d                   	pop    %rbp
  801ab2:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ab3:	48 98                	cltq
  801ab5:	eb ef                	jmp    801aa6 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ab7:	48 98                	cltq
  801ab9:	eb eb                	jmp    801aa6 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801abb:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  801ac2:	00 00 00 
  801ac5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801acb:	89 da                	mov    %ebx,%edx
  801acd:	48 bf 3e 33 80 00 00 	movabs $0x80333e,%rdi
  801ad4:	00 00 00 
  801ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  801adc:	48 b9 91 03 80 00 00 	movabs $0x800391,%rcx
  801ae3:	00 00 00 
  801ae6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ae8:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801aef:	eb b5                	jmp    801aa6 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801af1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801af8:	eb ac                	jmp    801aa6 <read+0x6e>

0000000000801afa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801afa:	f3 0f 1e fa          	endbr64
  801afe:	55                   	push   %rbp
  801aff:	48 89 e5             	mov    %rsp,%rbp
  801b02:	41 57                	push   %r15
  801b04:	41 56                	push   %r14
  801b06:	41 55                	push   %r13
  801b08:	41 54                	push   %r12
  801b0a:	53                   	push   %rbx
  801b0b:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b0f:	48 85 d2             	test   %rdx,%rdx
  801b12:	74 54                	je     801b68 <readn+0x6e>
  801b14:	41 89 fd             	mov    %edi,%r13d
  801b17:	49 89 f6             	mov    %rsi,%r14
  801b1a:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b1d:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b22:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b27:	49 bf 38 1a 80 00 00 	movabs $0x801a38,%r15
  801b2e:	00 00 00 
  801b31:	4c 89 e2             	mov    %r12,%rdx
  801b34:	48 29 f2             	sub    %rsi,%rdx
  801b37:	4c 01 f6             	add    %r14,%rsi
  801b3a:	44 89 ef             	mov    %r13d,%edi
  801b3d:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801b40:	85 c0                	test   %eax,%eax
  801b42:	78 20                	js     801b64 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801b44:	01 c3                	add    %eax,%ebx
  801b46:	85 c0                	test   %eax,%eax
  801b48:	74 08                	je     801b52 <readn+0x58>
  801b4a:	48 63 f3             	movslq %ebx,%rsi
  801b4d:	4c 39 e6             	cmp    %r12,%rsi
  801b50:	72 df                	jb     801b31 <readn+0x37>
    }
    return res;
  801b52:	48 63 c3             	movslq %ebx,%rax
}
  801b55:	48 83 c4 08          	add    $0x8,%rsp
  801b59:	5b                   	pop    %rbx
  801b5a:	41 5c                	pop    %r12
  801b5c:	41 5d                	pop    %r13
  801b5e:	41 5e                	pop    %r14
  801b60:	41 5f                	pop    %r15
  801b62:	5d                   	pop    %rbp
  801b63:	c3                   	ret
        if (inc < 0) return inc;
  801b64:	48 98                	cltq
  801b66:	eb ed                	jmp    801b55 <readn+0x5b>
    int inc = 1, res = 0;
  801b68:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b6d:	eb e3                	jmp    801b52 <readn+0x58>

0000000000801b6f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b6f:	f3 0f 1e fa          	endbr64
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	41 56                	push   %r14
  801b79:	41 55                	push   %r13
  801b7b:	41 54                	push   %r12
  801b7d:	53                   	push   %rbx
  801b7e:	48 83 ec 10          	sub    $0x10,%rsp
  801b82:	89 fb                	mov    %edi,%ebx
  801b84:	49 89 f4             	mov    %rsi,%r12
  801b87:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b8a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b8e:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	call   *%rax
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 47                	js     801be5 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b9e:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801ba2:	41 8b 3e             	mov    (%r14),%edi
  801ba5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ba9:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	call   *%rax
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 30                	js     801be9 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb9:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801bbe:	74 2d                	je     801bed <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801bc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bc4:	48 8b 40 18          	mov    0x18(%rax),%rax
  801bc8:	48 85 c0             	test   %rax,%rax
  801bcb:	74 56                	je     801c23 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801bcd:	4c 89 ea             	mov    %r13,%rdx
  801bd0:	4c 89 e6             	mov    %r12,%rsi
  801bd3:	4c 89 f7             	mov    %r14,%rdi
  801bd6:	ff d0                	call   *%rax
}
  801bd8:	48 83 c4 10          	add    $0x10,%rsp
  801bdc:	5b                   	pop    %rbx
  801bdd:	41 5c                	pop    %r12
  801bdf:	41 5d                	pop    %r13
  801be1:	41 5e                	pop    %r14
  801be3:	5d                   	pop    %rbp
  801be4:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801be5:	48 98                	cltq
  801be7:	eb ef                	jmp    801bd8 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801be9:	48 98                	cltq
  801beb:	eb eb                	jmp    801bd8 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bed:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  801bf4:	00 00 00 
  801bf7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bfd:	89 da                	mov    %ebx,%edx
  801bff:	48 bf 5a 33 80 00 00 	movabs $0x80335a,%rdi
  801c06:	00 00 00 
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0e:	48 b9 91 03 80 00 00 	movabs $0x800391,%rcx
  801c15:	00 00 00 
  801c18:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c1a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c21:	eb b5                	jmp    801bd8 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c23:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c2a:	eb ac                	jmp    801bd8 <write+0x69>

0000000000801c2c <seek>:

int
seek(int fdnum, off_t offset) {
  801c2c:	f3 0f 1e fa          	endbr64
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	53                   	push   %rbx
  801c35:	48 83 ec 18          	sub    $0x18,%rsp
  801c39:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c3b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c3f:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	call   *%rax
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 0c                	js     801c5b <seek+0x2f>

    fd->fd_offset = offset;
  801c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c53:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c5f:	c9                   	leave
  801c60:	c3                   	ret

0000000000801c61 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801c61:	f3 0f 1e fa          	endbr64
  801c65:	55                   	push   %rbp
  801c66:	48 89 e5             	mov    %rsp,%rbp
  801c69:	41 55                	push   %r13
  801c6b:	41 54                	push   %r12
  801c6d:	53                   	push   %rbx
  801c6e:	48 83 ec 18          	sub    $0x18,%rsp
  801c72:	89 fb                	mov    %edi,%ebx
  801c74:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c77:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c7b:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801c82:	00 00 00 
  801c85:	ff d0                	call   *%rax
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 38                	js     801cc3 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c8b:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801c8f:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801c93:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c97:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	call   *%rax
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 1c                	js     801cc3 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ca7:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801cac:	74 20                	je     801cce <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801cae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cb2:	48 8b 40 30          	mov    0x30(%rax),%rax
  801cb6:	48 85 c0             	test   %rax,%rax
  801cb9:	74 47                	je     801d02 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801cbb:	44 89 e6             	mov    %r12d,%esi
  801cbe:	4c 89 ef             	mov    %r13,%rdi
  801cc1:	ff d0                	call   *%rax
}
  801cc3:	48 83 c4 18          	add    $0x18,%rsp
  801cc7:	5b                   	pop    %rbx
  801cc8:	41 5c                	pop    %r12
  801cca:	41 5d                	pop    %r13
  801ccc:	5d                   	pop    %rbp
  801ccd:	c3                   	ret
                thisenv->env_id, fdnum);
  801cce:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  801cd5:	00 00 00 
  801cd8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cde:	89 da                	mov    %ebx,%edx
  801ce0:	48 bf 08 31 80 00 00 	movabs $0x803108,%rdi
  801ce7:	00 00 00 
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
  801cef:	48 b9 91 03 80 00 00 	movabs $0x800391,%rcx
  801cf6:	00 00 00 
  801cf9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d00:	eb c1                	jmp    801cc3 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d02:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d07:	eb ba                	jmp    801cc3 <ftruncate+0x62>

0000000000801d09 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d09:	f3 0f 1e fa          	endbr64
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	41 54                	push   %r12
  801d13:	53                   	push   %rbx
  801d14:	48 83 ec 10          	sub    $0x10,%rsp
  801d18:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d1b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d1f:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	call   *%rax
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	78 4e                	js     801d7d <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d2f:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801d33:	41 8b 3c 24          	mov    (%r12),%edi
  801d37:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d3b:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  801d42:	00 00 00 
  801d45:	ff d0                	call   *%rax
  801d47:	85 c0                	test   %eax,%eax
  801d49:	78 32                	js     801d7d <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d4f:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801d54:	74 30                	je     801d86 <fstat+0x7d>

    stat->st_name[0] = 0;
  801d56:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801d59:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801d60:	00 00 00 
    stat->st_isdir = 0;
  801d63:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801d6a:	00 00 00 
    stat->st_dev = dev;
  801d6d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801d74:	48 89 de             	mov    %rbx,%rsi
  801d77:	4c 89 e7             	mov    %r12,%rdi
  801d7a:	ff 50 28             	call   *0x28(%rax)
}
  801d7d:	48 83 c4 10          	add    $0x10,%rsp
  801d81:	5b                   	pop    %rbx
  801d82:	41 5c                	pop    %r12
  801d84:	5d                   	pop    %rbp
  801d85:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d86:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d8b:	eb f0                	jmp    801d7d <fstat+0x74>

0000000000801d8d <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d8d:	f3 0f 1e fa          	endbr64
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	41 54                	push   %r12
  801d97:	53                   	push   %rbx
  801d98:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d9b:	be 00 00 00 00       	mov    $0x0,%esi
  801da0:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	call   *%rax
  801dac:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801dae:	85 c0                	test   %eax,%eax
  801db0:	78 25                	js     801dd7 <stat+0x4a>

    int res = fstat(fd, stat);
  801db2:	4c 89 e6             	mov    %r12,%rsi
  801db5:	89 c7                	mov    %eax,%edi
  801db7:	48 b8 09 1d 80 00 00 	movabs $0x801d09,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	call   *%rax
  801dc3:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801dc6:	89 df                	mov    %ebx,%edi
  801dc8:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	call   *%rax

    return res;
  801dd4:	44 89 e3             	mov    %r12d,%ebx
}
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	5b                   	pop    %rbx
  801dda:	41 5c                	pop    %r12
  801ddc:	5d                   	pop    %rbp
  801ddd:	c3                   	ret

0000000000801dde <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801dde:	f3 0f 1e fa          	endbr64
  801de2:	55                   	push   %rbp
  801de3:	48 89 e5             	mov    %rsp,%rbp
  801de6:	41 54                	push   %r12
  801de8:	53                   	push   %rbx
  801de9:	48 83 ec 10          	sub    $0x10,%rsp
  801ded:	41 89 fc             	mov    %edi,%r12d
  801df0:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801df3:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  801dfa:	00 00 00 
  801dfd:	83 38 00             	cmpl   $0x0,(%rax)
  801e00:	74 6e                	je     801e70 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801e02:	bf 03 00 00 00       	mov    $0x3,%edi
  801e07:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  801e0e:	00 00 00 
  801e11:	ff d0                	call   *%rax
  801e13:	a3 00 70 c0 00 00 00 	movabs %eax,0xc07000
  801e1a:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e1c:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e22:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e27:	48 ba 00 60 c0 00 00 	movabs $0xc06000,%rdx
  801e2e:	00 00 00 
  801e31:	44 89 e6             	mov    %r12d,%esi
  801e34:	89 c7                	mov    %eax,%edi
  801e36:	48 b8 a3 2c 80 00 00 	movabs $0x802ca3,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801e42:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801e49:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e4f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e53:	48 89 de             	mov    %rbx,%rsi
  801e56:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5b:	48 b8 0a 2c 80 00 00 	movabs $0x802c0a,%rax
  801e62:	00 00 00 
  801e65:	ff d0                	call   *%rax
}
  801e67:	48 83 c4 10          	add    $0x10,%rsp
  801e6b:	5b                   	pop    %rbx
  801e6c:	41 5c                	pop    %r12
  801e6e:	5d                   	pop    %rbp
  801e6f:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e70:	bf 03 00 00 00       	mov    $0x3,%edi
  801e75:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	call   *%rax
  801e81:	a3 00 70 c0 00 00 00 	movabs %eax,0xc07000
  801e88:	00 00 
  801e8a:	e9 73 ff ff ff       	jmp    801e02 <fsipc+0x24>

0000000000801e8f <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801e8f:	f3 0f 1e fa          	endbr64
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e97:	48 b8 00 60 c0 00 00 	movabs $0xc06000,%rax
  801e9e:	00 00 00 
  801ea1:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ea4:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801ea6:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801ea9:	be 00 00 00 00       	mov    $0x0,%esi
  801eae:	bf 02 00 00 00       	mov    $0x2,%edi
  801eb3:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801eba:	00 00 00 
  801ebd:	ff d0                	call   *%rax
}
  801ebf:	5d                   	pop    %rbp
  801ec0:	c3                   	ret

0000000000801ec1 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801ec1:	f3 0f 1e fa          	endbr64
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ec9:	8b 47 0c             	mov    0xc(%rdi),%eax
  801ecc:	a3 00 60 c0 00 00 00 	movabs %eax,0xc06000
  801ed3:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801ed5:	be 00 00 00 00       	mov    $0x0,%esi
  801eda:	bf 06 00 00 00       	mov    $0x6,%edi
  801edf:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801ee6:	00 00 00 
  801ee9:	ff d0                	call   *%rax
}
  801eeb:	5d                   	pop    %rbp
  801eec:	c3                   	ret

0000000000801eed <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801eed:	f3 0f 1e fa          	endbr64
  801ef1:	55                   	push   %rbp
  801ef2:	48 89 e5             	mov    %rsp,%rbp
  801ef5:	41 54                	push   %r12
  801ef7:	53                   	push   %rbx
  801ef8:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801efb:	8b 47 0c             	mov    0xc(%rdi),%eax
  801efe:	a3 00 60 c0 00 00 00 	movabs %eax,0xc06000
  801f05:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f07:	be 00 00 00 00       	mov    $0x0,%esi
  801f0c:	bf 05 00 00 00       	mov    $0x5,%edi
  801f11:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	78 3d                	js     801f5e <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f21:	49 bc 00 60 c0 00 00 	movabs $0xc06000,%r12
  801f28:	00 00 00 
  801f2b:	4c 89 e6             	mov    %r12,%rsi
  801f2e:	48 89 df             	mov    %rbx,%rdi
  801f31:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  801f38:	00 00 00 
  801f3b:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801f3d:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801f44:	00 
  801f45:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f4b:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801f52:	00 
  801f53:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5e:	5b                   	pop    %rbx
  801f5f:	41 5c                	pop    %r12
  801f61:	5d                   	pop    %rbp
  801f62:	c3                   	ret

0000000000801f63 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801f63:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801f67:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801f6e:	77 41                	ja     801fb1 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801f70:	55                   	push   %rbp
  801f71:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f74:	48 b8 00 60 c0 00 00 	movabs $0xc06000,%rax
  801f7b:	00 00 00 
  801f7e:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801f81:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801f83:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801f87:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801f8b:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801f97:	be 00 00 00 00       	mov    $0x0,%esi
  801f9c:	bf 04 00 00 00       	mov    $0x4,%edi
  801fa1:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	call   *%rax
  801fad:	48 98                	cltq
}
  801faf:	5d                   	pop    %rbp
  801fb0:	c3                   	ret
        return -E_INVAL;
  801fb1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801fb8:	c3                   	ret

0000000000801fb9 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801fb9:	f3 0f 1e fa          	endbr64
  801fbd:	55                   	push   %rbp
  801fbe:	48 89 e5             	mov    %rsp,%rbp
  801fc1:	41 55                	push   %r13
  801fc3:	41 54                	push   %r12
  801fc5:	53                   	push   %rbx
  801fc6:	48 83 ec 08          	sub    $0x8,%rsp
  801fca:	49 89 f4             	mov    %rsi,%r12
  801fcd:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fd0:	48 b8 00 60 c0 00 00 	movabs $0xc06000,%rax
  801fd7:	00 00 00 
  801fda:	8b 57 0c             	mov    0xc(%rdi),%edx
  801fdd:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  801fdf:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  801fe3:	be 00 00 00 00       	mov    $0x0,%esi
  801fe8:	bf 03 00 00 00       	mov    $0x3,%edi
  801fed:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	call   *%rax
  801ff9:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801ffc:	4d 85 ed             	test   %r13,%r13
  801fff:	78 2a                	js     80202b <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802001:	4c 89 ea             	mov    %r13,%rdx
  802004:	4c 39 eb             	cmp    %r13,%rbx
  802007:	72 30                	jb     802039 <devfile_read+0x80>
  802009:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802010:	7f 27                	jg     802039 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802012:	48 be 00 60 c0 00 00 	movabs $0xc06000,%rsi
  802019:	00 00 00 
  80201c:	4c 89 e7             	mov    %r12,%rdi
  80201f:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  802026:	00 00 00 
  802029:	ff d0                	call   *%rax
}
  80202b:	4c 89 e8             	mov    %r13,%rax
  80202e:	48 83 c4 08          	add    $0x8,%rsp
  802032:	5b                   	pop    %rbx
  802033:	41 5c                	pop    %r12
  802035:	41 5d                	pop    %r13
  802037:	5d                   	pop    %rbp
  802038:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802039:	48 b9 77 33 80 00 00 	movabs $0x803377,%rcx
  802040:	00 00 00 
  802043:	48 ba 94 33 80 00 00 	movabs $0x803394,%rdx
  80204a:	00 00 00 
  80204d:	be 7b 00 00 00       	mov    $0x7b,%esi
  802052:	48 bf a9 33 80 00 00 	movabs $0x8033a9,%rdi
  802059:	00 00 00 
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	49 b8 35 02 80 00 00 	movabs $0x800235,%r8
  802068:	00 00 00 
  80206b:	41 ff d0             	call   *%r8

000000000080206e <open>:
open(const char *path, int mode) {
  80206e:	f3 0f 1e fa          	endbr64
  802072:	55                   	push   %rbp
  802073:	48 89 e5             	mov    %rsp,%rbp
  802076:	41 55                	push   %r13
  802078:	41 54                	push   %r12
  80207a:	53                   	push   %rbx
  80207b:	48 83 ec 18          	sub    $0x18,%rsp
  80207f:	49 89 fc             	mov    %rdi,%r12
  802082:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802085:	48 b8 95 0c 80 00 00 	movabs $0x800c95,%rax
  80208c:	00 00 00 
  80208f:	ff d0                	call   *%rax
  802091:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802097:	0f 87 8a 00 00 00    	ja     802127 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80209d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8020a1:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	call   *%rax
  8020ad:	89 c3                	mov    %eax,%ebx
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 50                	js     802103 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8020b3:	4c 89 e6             	mov    %r12,%rsi
  8020b6:	48 bb 00 60 c0 00 00 	movabs $0xc06000,%rbx
  8020bd:	00 00 00 
  8020c0:	48 89 df             	mov    %rbx,%rdi
  8020c3:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  8020ca:	00 00 00 
  8020cd:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8020cf:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020d6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8020da:	bf 01 00 00 00       	mov    $0x1,%edi
  8020df:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	call   *%rax
  8020eb:	89 c3                	mov    %eax,%ebx
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 1f                	js     802110 <open+0xa2>
    return fd2num(fd);
  8020f1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020f5:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	call   *%rax
  802101:	89 c3                	mov    %eax,%ebx
}
  802103:	89 d8                	mov    %ebx,%eax
  802105:	48 83 c4 18          	add    $0x18,%rsp
  802109:	5b                   	pop    %rbx
  80210a:	41 5c                	pop    %r12
  80210c:	41 5d                	pop    %r13
  80210e:	5d                   	pop    %rbp
  80210f:	c3                   	ret
        fd_close(fd, 0);
  802110:	be 00 00 00 00       	mov    $0x0,%esi
  802115:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802119:	48 b8 00 18 80 00 00 	movabs $0x801800,%rax
  802120:	00 00 00 
  802123:	ff d0                	call   *%rax
        return res;
  802125:	eb dc                	jmp    802103 <open+0x95>
        return -E_BAD_PATH;
  802127:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80212c:	eb d5                	jmp    802103 <open+0x95>

000000000080212e <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80212e:	f3 0f 1e fa          	endbr64
  802132:	55                   	push   %rbp
  802133:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802136:	be 00 00 00 00       	mov    $0x0,%esi
  80213b:	bf 08 00 00 00       	mov    $0x8,%edi
  802140:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802147:	00 00 00 
  80214a:	ff d0                	call   *%rax
}
  80214c:	5d                   	pop    %rbp
  80214d:	c3                   	ret

000000000080214e <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80214e:	f3 0f 1e fa          	endbr64
  802152:	55                   	push   %rbp
  802153:	48 89 e5             	mov    %rsp,%rbp
  802156:	41 54                	push   %r12
  802158:	53                   	push   %rbx
  802159:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80215c:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  802163:	00 00 00 
  802166:	ff d0                	call   *%rax
  802168:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80216b:	48 be b4 33 80 00 00 	movabs $0x8033b4,%rsi
  802172:	00 00 00 
  802175:	48 89 df             	mov    %rbx,%rdi
  802178:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  80217f:	00 00 00 
  802182:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802184:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802189:	41 2b 04 24          	sub    (%r12),%eax
  80218d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802193:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80219a:	00 00 00 
    stat->st_dev = &devpipe;
  80219d:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8021a4:	00 00 00 
  8021a7:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	5b                   	pop    %rbx
  8021b4:	41 5c                	pop    %r12
  8021b6:	5d                   	pop    %rbp
  8021b7:	c3                   	ret

00000000008021b8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8021b8:	f3 0f 1e fa          	endbr64
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	41 54                	push   %r12
  8021c2:	53                   	push   %rbx
  8021c3:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8021c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021cb:	48 89 fe             	mov    %rdi,%rsi
  8021ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d3:	49 bc 1f 14 80 00 00 	movabs $0x80141f,%r12
  8021da:	00 00 00 
  8021dd:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8021e0:	48 89 df             	mov    %rbx,%rdi
  8021e3:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	call   *%rax
  8021ef:	48 89 c6             	mov    %rax,%rsi
  8021f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fc:	41 ff d4             	call   *%r12
}
  8021ff:	5b                   	pop    %rbx
  802200:	41 5c                	pop    %r12
  802202:	5d                   	pop    %rbp
  802203:	c3                   	ret

0000000000802204 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802204:	f3 0f 1e fa          	endbr64
  802208:	55                   	push   %rbp
  802209:	48 89 e5             	mov    %rsp,%rbp
  80220c:	41 57                	push   %r15
  80220e:	41 56                	push   %r14
  802210:	41 55                	push   %r13
  802212:	41 54                	push   %r12
  802214:	53                   	push   %rbx
  802215:	48 83 ec 18          	sub    $0x18,%rsp
  802219:	49 89 fc             	mov    %rdi,%r12
  80221c:	49 89 f5             	mov    %rsi,%r13
  80221f:	49 89 d7             	mov    %rdx,%r15
  802222:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802226:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  80222d:	00 00 00 
  802230:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802232:	4d 85 ff             	test   %r15,%r15
  802235:	0f 84 af 00 00 00    	je     8022ea <devpipe_write+0xe6>
  80223b:	48 89 c3             	mov    %rax,%rbx
  80223e:	4c 89 f8             	mov    %r15,%rax
  802241:	4d 89 ef             	mov    %r13,%r15
  802244:	4c 01 e8             	add    %r13,%rax
  802247:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80224b:	49 bd af 12 80 00 00 	movabs $0x8012af,%r13
  802252:	00 00 00 
            sys_yield();
  802255:	49 be 44 12 80 00 00 	movabs $0x801244,%r14
  80225c:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80225f:	8b 73 04             	mov    0x4(%rbx),%esi
  802262:	48 63 ce             	movslq %esi,%rcx
  802265:	48 63 03             	movslq (%rbx),%rax
  802268:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80226e:	48 39 c1             	cmp    %rax,%rcx
  802271:	72 2e                	jb     8022a1 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802273:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802278:	48 89 da             	mov    %rbx,%rdx
  80227b:	be 00 10 00 00       	mov    $0x1000,%esi
  802280:	4c 89 e7             	mov    %r12,%rdi
  802283:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802286:	85 c0                	test   %eax,%eax
  802288:	74 66                	je     8022f0 <devpipe_write+0xec>
            sys_yield();
  80228a:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80228d:	8b 73 04             	mov    0x4(%rbx),%esi
  802290:	48 63 ce             	movslq %esi,%rcx
  802293:	48 63 03             	movslq (%rbx),%rax
  802296:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80229c:	48 39 c1             	cmp    %rax,%rcx
  80229f:	73 d2                	jae    802273 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022a1:	41 0f b6 3f          	movzbl (%r15),%edi
  8022a5:	48 89 ca             	mov    %rcx,%rdx
  8022a8:	48 c1 ea 03          	shr    $0x3,%rdx
  8022ac:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8022b3:	08 10 20 
  8022b6:	48 f7 e2             	mul    %rdx
  8022b9:	48 c1 ea 06          	shr    $0x6,%rdx
  8022bd:	48 89 d0             	mov    %rdx,%rax
  8022c0:	48 c1 e0 09          	shl    $0x9,%rax
  8022c4:	48 29 d0             	sub    %rdx,%rax
  8022c7:	48 c1 e0 03          	shl    $0x3,%rax
  8022cb:	48 29 c1             	sub    %rax,%rcx
  8022ce:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8022d3:	83 c6 01             	add    $0x1,%esi
  8022d6:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8022d9:	49 83 c7 01          	add    $0x1,%r15
  8022dd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8022e1:	49 39 c7             	cmp    %rax,%r15
  8022e4:	0f 85 75 ff ff ff    	jne    80225f <devpipe_write+0x5b>
    return n;
  8022ea:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8022ee:	eb 05                	jmp    8022f5 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f5:	48 83 c4 18          	add    $0x18,%rsp
  8022f9:	5b                   	pop    %rbx
  8022fa:	41 5c                	pop    %r12
  8022fc:	41 5d                	pop    %r13
  8022fe:	41 5e                	pop    %r14
  802300:	41 5f                	pop    %r15
  802302:	5d                   	pop    %rbp
  802303:	c3                   	ret

0000000000802304 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802304:	f3 0f 1e fa          	endbr64
  802308:	55                   	push   %rbp
  802309:	48 89 e5             	mov    %rsp,%rbp
  80230c:	41 57                	push   %r15
  80230e:	41 56                	push   %r14
  802310:	41 55                	push   %r13
  802312:	41 54                	push   %r12
  802314:	53                   	push   %rbx
  802315:	48 83 ec 18          	sub    $0x18,%rsp
  802319:	49 89 fc             	mov    %rdi,%r12
  80231c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802320:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802324:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	call   *%rax
  802330:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802333:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802339:	49 bd af 12 80 00 00 	movabs $0x8012af,%r13
  802340:	00 00 00 
            sys_yield();
  802343:	49 be 44 12 80 00 00 	movabs $0x801244,%r14
  80234a:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80234d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802352:	74 7d                	je     8023d1 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802354:	8b 03                	mov    (%rbx),%eax
  802356:	3b 43 04             	cmp    0x4(%rbx),%eax
  802359:	75 26                	jne    802381 <devpipe_read+0x7d>
            if (i > 0) return i;
  80235b:	4d 85 ff             	test   %r15,%r15
  80235e:	75 77                	jne    8023d7 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802360:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802365:	48 89 da             	mov    %rbx,%rdx
  802368:	be 00 10 00 00       	mov    $0x1000,%esi
  80236d:	4c 89 e7             	mov    %r12,%rdi
  802370:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802373:	85 c0                	test   %eax,%eax
  802375:	74 72                	je     8023e9 <devpipe_read+0xe5>
            sys_yield();
  802377:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80237a:	8b 03                	mov    (%rbx),%eax
  80237c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80237f:	74 df                	je     802360 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802381:	48 63 c8             	movslq %eax,%rcx
  802384:	48 89 ca             	mov    %rcx,%rdx
  802387:	48 c1 ea 03          	shr    $0x3,%rdx
  80238b:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802392:	08 10 20 
  802395:	48 89 d0             	mov    %rdx,%rax
  802398:	48 f7 e6             	mul    %rsi
  80239b:	48 c1 ea 06          	shr    $0x6,%rdx
  80239f:	48 89 d0             	mov    %rdx,%rax
  8023a2:	48 c1 e0 09          	shl    $0x9,%rax
  8023a6:	48 29 d0             	sub    %rdx,%rax
  8023a9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023b0:	00 
  8023b1:	48 89 c8             	mov    %rcx,%rax
  8023b4:	48 29 d0             	sub    %rdx,%rax
  8023b7:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8023bc:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8023c0:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8023c4:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8023c7:	49 83 c7 01          	add    $0x1,%r15
  8023cb:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8023cf:	75 83                	jne    802354 <devpipe_read+0x50>
    return n;
  8023d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8023d5:	eb 03                	jmp    8023da <devpipe_read+0xd6>
            if (i > 0) return i;
  8023d7:	4c 89 f8             	mov    %r15,%rax
}
  8023da:	48 83 c4 18          	add    $0x18,%rsp
  8023de:	5b                   	pop    %rbx
  8023df:	41 5c                	pop    %r12
  8023e1:	41 5d                	pop    %r13
  8023e3:	41 5e                	pop    %r14
  8023e5:	41 5f                	pop    %r15
  8023e7:	5d                   	pop    %rbp
  8023e8:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8023e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ee:	eb ea                	jmp    8023da <devpipe_read+0xd6>

00000000008023f0 <pipe>:
pipe(int pfd[2]) {
  8023f0:	f3 0f 1e fa          	endbr64
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	41 55                	push   %r13
  8023fa:	41 54                	push   %r12
  8023fc:	53                   	push   %rbx
  8023fd:	48 83 ec 18          	sub    $0x18,%rsp
  802401:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802404:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802408:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  80240f:	00 00 00 
  802412:	ff d0                	call   *%rax
  802414:	89 c3                	mov    %eax,%ebx
  802416:	85 c0                	test   %eax,%eax
  802418:	0f 88 a0 01 00 00    	js     8025be <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80241e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802423:	ba 00 10 00 00       	mov    $0x1000,%edx
  802428:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80242c:	bf 00 00 00 00       	mov    $0x0,%edi
  802431:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  802438:	00 00 00 
  80243b:	ff d0                	call   *%rax
  80243d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80243f:	85 c0                	test   %eax,%eax
  802441:	0f 88 77 01 00 00    	js     8025be <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802447:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80244b:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  802452:	00 00 00 
  802455:	ff d0                	call   *%rax
  802457:	89 c3                	mov    %eax,%ebx
  802459:	85 c0                	test   %eax,%eax
  80245b:	0f 88 43 01 00 00    	js     8025a4 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802461:	b9 46 00 00 00       	mov    $0x46,%ecx
  802466:	ba 00 10 00 00       	mov    $0x1000,%edx
  80246b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80246f:	bf 00 00 00 00       	mov    $0x0,%edi
  802474:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	call   *%rax
  802480:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802482:	85 c0                	test   %eax,%eax
  802484:	0f 88 1a 01 00 00    	js     8025a4 <pipe+0x1b4>
    va = fd2data(fd0);
  80248a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80248e:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  802495:	00 00 00 
  802498:	ff d0                	call   *%rax
  80249a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80249d:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024a7:	48 89 c6             	mov    %rax,%rsi
  8024aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8024af:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	call   *%rax
  8024bb:	89 c3                	mov    %eax,%ebx
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	0f 88 c5 00 00 00    	js     80258a <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8024c5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8024c9:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	call   *%rax
  8024d5:	48 89 c1             	mov    %rax,%rcx
  8024d8:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8024de:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8024e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e9:	4c 89 ee             	mov    %r13,%rsi
  8024ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f1:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  8024f8:	00 00 00 
  8024fb:	ff d0                	call   *%rax
  8024fd:	89 c3                	mov    %eax,%ebx
  8024ff:	85 c0                	test   %eax,%eax
  802501:	78 6e                	js     802571 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802503:	be 00 10 00 00       	mov    $0x1000,%esi
  802508:	4c 89 ef             	mov    %r13,%rdi
  80250b:	48 b8 79 12 80 00 00 	movabs $0x801279,%rax
  802512:	00 00 00 
  802515:	ff d0                	call   *%rax
  802517:	83 f8 02             	cmp    $0x2,%eax
  80251a:	0f 85 ab 00 00 00    	jne    8025cb <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802520:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802527:	00 00 
  802529:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80252d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80252f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802533:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80253a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80253e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802540:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802544:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80254b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80254f:	48 bb a3 16 80 00 00 	movabs $0x8016a3,%rbx
  802556:	00 00 00 
  802559:	ff d3                	call   *%rbx
  80255b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80255f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802563:	ff d3                	call   *%rbx
  802565:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80256a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80256f:	eb 4d                	jmp    8025be <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802571:	ba 00 10 00 00       	mov    $0x1000,%edx
  802576:	4c 89 ee             	mov    %r13,%rsi
  802579:	bf 00 00 00 00       	mov    $0x0,%edi
  80257e:	48 b8 1f 14 80 00 00 	movabs $0x80141f,%rax
  802585:	00 00 00 
  802588:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80258a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80258f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802593:	bf 00 00 00 00       	mov    $0x0,%edi
  802598:	48 b8 1f 14 80 00 00 	movabs $0x80141f,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8025a4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025a9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b2:	48 b8 1f 14 80 00 00 	movabs $0x80141f,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	call   *%rax
}
  8025be:	89 d8                	mov    %ebx,%eax
  8025c0:	48 83 c4 18          	add    $0x18,%rsp
  8025c4:	5b                   	pop    %rbx
  8025c5:	41 5c                	pop    %r12
  8025c7:	41 5d                	pop    %r13
  8025c9:	5d                   	pop    %rbp
  8025ca:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8025cb:	48 b9 30 31 80 00 00 	movabs $0x803130,%rcx
  8025d2:	00 00 00 
  8025d5:	48 ba 94 33 80 00 00 	movabs $0x803394,%rdx
  8025dc:	00 00 00 
  8025df:	be 2e 00 00 00       	mov    $0x2e,%esi
  8025e4:	48 bf bb 33 80 00 00 	movabs $0x8033bb,%rdi
  8025eb:	00 00 00 
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	49 b8 35 02 80 00 00 	movabs $0x800235,%r8
  8025fa:	00 00 00 
  8025fd:	41 ff d0             	call   *%r8

0000000000802600 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802600:	f3 0f 1e fa          	endbr64
  802604:	55                   	push   %rbp
  802605:	48 89 e5             	mov    %rsp,%rbp
  802608:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80260c:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802610:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  802617:	00 00 00 
  80261a:	ff d0                	call   *%rax
    if (res < 0) return res;
  80261c:	85 c0                	test   %eax,%eax
  80261e:	78 35                	js     802655 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802620:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802624:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	call   *%rax
  802630:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802633:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802638:	be 00 10 00 00       	mov    $0x1000,%esi
  80263d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802641:	48 b8 af 12 80 00 00 	movabs $0x8012af,%rax
  802648:	00 00 00 
  80264b:	ff d0                	call   *%rax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	0f 94 c0             	sete   %al
  802652:	0f b6 c0             	movzbl %al,%eax
}
  802655:	c9                   	leave
  802656:	c3                   	ret

0000000000802657 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802657:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80265b:	48 89 f8             	mov    %rdi,%rax
  80265e:	48 c1 e8 27          	shr    $0x27,%rax
  802662:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802669:	7f 00 00 
  80266c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802670:	f6 c2 01             	test   $0x1,%dl
  802673:	74 6d                	je     8026e2 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802675:	48 89 f8             	mov    %rdi,%rax
  802678:	48 c1 e8 1e          	shr    $0x1e,%rax
  80267c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802683:	7f 00 00 
  802686:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80268a:	f6 c2 01             	test   $0x1,%dl
  80268d:	74 62                	je     8026f1 <get_uvpt_entry+0x9a>
  80268f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802696:	7f 00 00 
  802699:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80269d:	f6 c2 80             	test   $0x80,%dl
  8026a0:	75 4f                	jne    8026f1 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8026a2:	48 89 f8             	mov    %rdi,%rax
  8026a5:	48 c1 e8 15          	shr    $0x15,%rax
  8026a9:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8026b0:	7f 00 00 
  8026b3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026b7:	f6 c2 01             	test   $0x1,%dl
  8026ba:	74 44                	je     802700 <get_uvpt_entry+0xa9>
  8026bc:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8026c3:	7f 00 00 
  8026c6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026ca:	f6 c2 80             	test   $0x80,%dl
  8026cd:	75 31                	jne    802700 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8026cf:	48 c1 ef 0c          	shr    $0xc,%rdi
  8026d3:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8026da:	7f 00 00 
  8026dd:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8026e1:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8026e2:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8026e9:	7f 00 00 
  8026ec:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8026f0:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8026f1:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8026f8:	7f 00 00 
  8026fb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8026ff:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802700:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802707:	7f 00 00 
  80270a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80270e:	c3                   	ret

000000000080270f <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80270f:	f3 0f 1e fa          	endbr64
  802713:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802716:	48 89 f9             	mov    %rdi,%rcx
  802719:	48 c1 e9 27          	shr    $0x27,%rcx
  80271d:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802724:	7f 00 00 
  802727:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80272b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802732:	f6 c1 01             	test   $0x1,%cl
  802735:	0f 84 b2 00 00 00    	je     8027ed <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80273b:	48 89 f9             	mov    %rdi,%rcx
  80273e:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802742:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802749:	7f 00 00 
  80274c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802750:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802757:	40 f6 c6 01          	test   $0x1,%sil
  80275b:	0f 84 8c 00 00 00    	je     8027ed <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802761:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802768:	7f 00 00 
  80276b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80276f:	a8 80                	test   $0x80,%al
  802771:	75 7b                	jne    8027ee <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802773:	48 89 f9             	mov    %rdi,%rcx
  802776:	48 c1 e9 15          	shr    $0x15,%rcx
  80277a:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802781:	7f 00 00 
  802784:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802788:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80278f:	40 f6 c6 01          	test   $0x1,%sil
  802793:	74 58                	je     8027ed <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802795:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80279c:	7f 00 00 
  80279f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027a3:	a8 80                	test   $0x80,%al
  8027a5:	75 6c                	jne    802813 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8027a7:	48 89 f9             	mov    %rdi,%rcx
  8027aa:	48 c1 e9 0c          	shr    $0xc,%rcx
  8027ae:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027b5:	7f 00 00 
  8027b8:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8027bc:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8027c3:	40 f6 c6 01          	test   $0x1,%sil
  8027c7:	74 24                	je     8027ed <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8027c9:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027d0:	7f 00 00 
  8027d3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027d7:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8027de:	ff ff 7f 
  8027e1:	48 21 c8             	and    %rcx,%rax
  8027e4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8027ea:	48 09 d0             	or     %rdx,%rax
}
  8027ed:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8027ee:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8027f5:	7f 00 00 
  8027f8:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027fc:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802803:	ff ff 7f 
  802806:	48 21 c8             	and    %rcx,%rax
  802809:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80280f:	48 01 d0             	add    %rdx,%rax
  802812:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802813:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80281a:	7f 00 00 
  80281d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802821:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802828:	ff ff 7f 
  80282b:	48 21 c8             	and    %rcx,%rax
  80282e:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802834:	48 01 d0             	add    %rdx,%rax
  802837:	c3                   	ret

0000000000802838 <get_prot>:

int
get_prot(void *va) {
  802838:	f3 0f 1e fa          	endbr64
  80283c:	55                   	push   %rbp
  80283d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802840:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  802847:	00 00 00 
  80284a:	ff d0                	call   *%rax
  80284c:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  80284f:	83 e0 01             	and    $0x1,%eax
  802852:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802855:	89 d1                	mov    %edx,%ecx
  802857:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  80285d:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80285f:	89 c1                	mov    %eax,%ecx
  802861:	83 c9 02             	or     $0x2,%ecx
  802864:	f6 c2 02             	test   $0x2,%dl
  802867:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80286a:	89 c1                	mov    %eax,%ecx
  80286c:	83 c9 01             	or     $0x1,%ecx
  80286f:	48 85 d2             	test   %rdx,%rdx
  802872:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802875:	89 c1                	mov    %eax,%ecx
  802877:	83 c9 40             	or     $0x40,%ecx
  80287a:	f6 c6 04             	test   $0x4,%dh
  80287d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802880:	5d                   	pop    %rbp
  802881:	c3                   	ret

0000000000802882 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802882:	f3 0f 1e fa          	endbr64
  802886:	55                   	push   %rbp
  802887:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80288a:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  802891:	00 00 00 
  802894:	ff d0                	call   *%rax
    return pte & PTE_D;
  802896:	48 c1 e8 06          	shr    $0x6,%rax
  80289a:	83 e0 01             	and    $0x1,%eax
}
  80289d:	5d                   	pop    %rbp
  80289e:	c3                   	ret

000000000080289f <is_page_present>:

bool
is_page_present(void *va) {
  80289f:	f3 0f 1e fa          	endbr64
  8028a3:	55                   	push   %rbp
  8028a4:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028a7:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  8028ae:	00 00 00 
  8028b1:	ff d0                	call   *%rax
  8028b3:	83 e0 01             	and    $0x1,%eax
}
  8028b6:	5d                   	pop    %rbp
  8028b7:	c3                   	ret

00000000008028b8 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028b8:	f3 0f 1e fa          	endbr64
  8028bc:	55                   	push   %rbp
  8028bd:	48 89 e5             	mov    %rsp,%rbp
  8028c0:	41 57                	push   %r15
  8028c2:	41 56                	push   %r14
  8028c4:	41 55                	push   %r13
  8028c6:	41 54                	push   %r12
  8028c8:	53                   	push   %rbx
  8028c9:	48 83 ec 18          	sub    $0x18,%rsp
  8028cd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8028d1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8028d5:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8028da:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8028e1:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8028e4:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8028eb:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8028ee:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8028f5:	00 00 00 
  8028f8:	eb 73                	jmp    80296d <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8028fa:	48 89 d8             	mov    %rbx,%rax
  8028fd:	48 c1 e8 15          	shr    $0x15,%rax
  802901:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802908:	7f 00 00 
  80290b:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80290f:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802915:	f6 c2 01             	test   $0x1,%dl
  802918:	74 4b                	je     802965 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80291a:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80291e:	f6 c2 80             	test   $0x80,%dl
  802921:	74 11                	je     802934 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802923:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802927:	f6 c4 04             	test   $0x4,%ah
  80292a:	74 39                	je     802965 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80292c:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802932:	eb 20                	jmp    802954 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802934:	48 89 da             	mov    %rbx,%rdx
  802937:	48 c1 ea 0c          	shr    $0xc,%rdx
  80293b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802942:	7f 00 00 
  802945:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802949:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80294f:	f6 c4 04             	test   $0x4,%ah
  802952:	74 11                	je     802965 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802954:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802958:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80295c:	48 89 df             	mov    %rbx,%rdi
  80295f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802963:	ff d0                	call   *%rax
    next:
        va += size;
  802965:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802968:	49 39 df             	cmp    %rbx,%r15
  80296b:	72 3e                	jb     8029ab <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80296d:	49 8b 06             	mov    (%r14),%rax
  802970:	a8 01                	test   $0x1,%al
  802972:	74 37                	je     8029ab <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802974:	48 89 d8             	mov    %rbx,%rax
  802977:	48 c1 e8 1e          	shr    $0x1e,%rax
  80297b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802980:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802986:	f6 c2 01             	test   $0x1,%dl
  802989:	74 da                	je     802965 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80298b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802990:	f6 c2 80             	test   $0x80,%dl
  802993:	0f 84 61 ff ff ff    	je     8028fa <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802999:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80299e:	f6 c4 04             	test   $0x4,%ah
  8029a1:	74 c2                	je     802965 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8029a3:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8029a9:	eb a9                	jmp    802954 <foreach_shared_region+0x9c>
    }
    return res;
}
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	48 83 c4 18          	add    $0x18,%rsp
  8029b4:	5b                   	pop    %rbx
  8029b5:	41 5c                	pop    %r12
  8029b7:	41 5d                	pop    %r13
  8029b9:	41 5e                	pop    %r14
  8029bb:	41 5f                	pop    %r15
  8029bd:	5d                   	pop    %rbp
  8029be:	c3                   	ret

00000000008029bf <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8029bf:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c8:	c3                   	ret

00000000008029c9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8029c9:	f3 0f 1e fa          	endbr64
  8029cd:	55                   	push   %rbp
  8029ce:	48 89 e5             	mov    %rsp,%rbp
  8029d1:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8029d4:	48 be cb 33 80 00 00 	movabs $0x8033cb,%rsi
  8029db:	00 00 00 
  8029de:	48 b8 da 0c 80 00 00 	movabs $0x800cda,%rax
  8029e5:	00 00 00 
  8029e8:	ff d0                	call   *%rax
    return 0;
}
  8029ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ef:	5d                   	pop    %rbp
  8029f0:	c3                   	ret

00000000008029f1 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029f1:	f3 0f 1e fa          	endbr64
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	41 57                	push   %r15
  8029fb:	41 56                	push   %r14
  8029fd:	41 55                	push   %r13
  8029ff:	41 54                	push   %r12
  802a01:	53                   	push   %rbx
  802a02:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a09:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a10:	48 85 d2             	test   %rdx,%rdx
  802a13:	74 7a                	je     802a8f <devcons_write+0x9e>
  802a15:	49 89 d6             	mov    %rdx,%r14
  802a18:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a1e:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802a23:	49 bf f5 0e 80 00 00 	movabs $0x800ef5,%r15
  802a2a:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a2d:	4c 89 f3             	mov    %r14,%rbx
  802a30:	48 29 f3             	sub    %rsi,%rbx
  802a33:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a38:	48 39 c3             	cmp    %rax,%rbx
  802a3b:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a3f:	4c 63 eb             	movslq %ebx,%r13
  802a42:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802a49:	48 01 c6             	add    %rax,%rsi
  802a4c:	4c 89 ea             	mov    %r13,%rdx
  802a4f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a56:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a59:	4c 89 ee             	mov    %r13,%rsi
  802a5c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a63:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a6f:	41 01 dc             	add    %ebx,%r12d
  802a72:	49 63 f4             	movslq %r12d,%rsi
  802a75:	4c 39 f6             	cmp    %r14,%rsi
  802a78:	72 b3                	jb     802a2d <devcons_write+0x3c>
    return res;
  802a7a:	49 63 c4             	movslq %r12d,%rax
}
  802a7d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802a84:	5b                   	pop    %rbx
  802a85:	41 5c                	pop    %r12
  802a87:	41 5d                	pop    %r13
  802a89:	41 5e                	pop    %r14
  802a8b:	41 5f                	pop    %r15
  802a8d:	5d                   	pop    %rbp
  802a8e:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802a8f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a95:	eb e3                	jmp    802a7a <devcons_write+0x89>

0000000000802a97 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a97:	f3 0f 1e fa          	endbr64
  802a9b:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa3:	48 85 c0             	test   %rax,%rax
  802aa6:	74 55                	je     802afd <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802aa8:	55                   	push   %rbp
  802aa9:	48 89 e5             	mov    %rsp,%rbp
  802aac:	41 55                	push   %r13
  802aae:	41 54                	push   %r12
  802ab0:	53                   	push   %rbx
  802ab1:	48 83 ec 08          	sub    $0x8,%rsp
  802ab5:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802ab8:	48 bb 6b 11 80 00 00 	movabs $0x80116b,%rbx
  802abf:	00 00 00 
  802ac2:	49 bc 44 12 80 00 00 	movabs $0x801244,%r12
  802ac9:	00 00 00 
  802acc:	eb 03                	jmp    802ad1 <devcons_read+0x3a>
  802ace:	41 ff d4             	call   *%r12
  802ad1:	ff d3                	call   *%rbx
  802ad3:	85 c0                	test   %eax,%eax
  802ad5:	74 f7                	je     802ace <devcons_read+0x37>
    if (c < 0) return c;
  802ad7:	48 63 d0             	movslq %eax,%rdx
  802ada:	78 13                	js     802aef <devcons_read+0x58>
    if (c == 0x04) return 0;
  802adc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae1:	83 f8 04             	cmp    $0x4,%eax
  802ae4:	74 09                	je     802aef <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802ae6:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802aea:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802aef:	48 89 d0             	mov    %rdx,%rax
  802af2:	48 83 c4 08          	add    $0x8,%rsp
  802af6:	5b                   	pop    %rbx
  802af7:	41 5c                	pop    %r12
  802af9:	41 5d                	pop    %r13
  802afb:	5d                   	pop    %rbp
  802afc:	c3                   	ret
  802afd:	48 89 d0             	mov    %rdx,%rax
  802b00:	c3                   	ret

0000000000802b01 <cputchar>:
cputchar(int ch) {
  802b01:	f3 0f 1e fa          	endbr64
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
  802b09:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b0d:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b11:	be 01 00 00 00       	mov    $0x1,%esi
  802b16:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802b1a:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	call   *%rax
}
  802b26:	c9                   	leave
  802b27:	c3                   	ret

0000000000802b28 <getchar>:
getchar(void) {
  802b28:	f3 0f 1e fa          	endbr64
  802b2c:	55                   	push   %rbp
  802b2d:	48 89 e5             	mov    %rsp,%rbp
  802b30:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b34:	ba 01 00 00 00       	mov    $0x1,%edx
  802b39:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b3d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b42:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	call   *%rax
  802b4e:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b50:	85 c0                	test   %eax,%eax
  802b52:	78 06                	js     802b5a <getchar+0x32>
  802b54:	74 08                	je     802b5e <getchar+0x36>
  802b56:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b5a:	89 d0                	mov    %edx,%eax
  802b5c:	c9                   	leave
  802b5d:	c3                   	ret
    return res < 0 ? res : res ? c :
  802b5e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b63:	eb f5                	jmp    802b5a <getchar+0x32>

0000000000802b65 <iscons>:
iscons(int fdnum) {
  802b65:	f3 0f 1e fa          	endbr64
  802b69:	55                   	push   %rbp
  802b6a:	48 89 e5             	mov    %rsp,%rbp
  802b6d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b71:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b75:	48 b8 3d 17 80 00 00 	movabs $0x80173d,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b81:	85 c0                	test   %eax,%eax
  802b83:	78 18                	js     802b9d <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802b85:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b89:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802b90:	00 00 00 
  802b93:	8b 00                	mov    (%rax),%eax
  802b95:	39 02                	cmp    %eax,(%rdx)
  802b97:	0f 94 c0             	sete   %al
  802b9a:	0f b6 c0             	movzbl %al,%eax
}
  802b9d:	c9                   	leave
  802b9e:	c3                   	ret

0000000000802b9f <opencons>:
opencons(void) {
  802b9f:	f3 0f 1e fa          	endbr64
  802ba3:	55                   	push   %rbp
  802ba4:	48 89 e5             	mov    %rsp,%rbp
  802ba7:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802bab:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802baf:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  802bb6:	00 00 00 
  802bb9:	ff d0                	call   *%rax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	78 49                	js     802c08 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802bbf:	b9 46 00 00 00       	mov    $0x46,%ecx
  802bc4:	ba 00 10 00 00       	mov    $0x1000,%edx
  802bc9:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802bcd:	bf 00 00 00 00       	mov    $0x0,%edi
  802bd2:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	call   *%rax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	78 26                	js     802c08 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802be2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802be6:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802bed:	00 00 
  802bef:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802bf1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802bf5:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802bfc:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	call   *%rax
}
  802c08:	c9                   	leave
  802c09:	c3                   	ret

0000000000802c0a <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802c0a:	f3 0f 1e fa          	endbr64
  802c0e:	55                   	push   %rbp
  802c0f:	48 89 e5             	mov    %rsp,%rbp
  802c12:	41 54                	push   %r12
  802c14:	53                   	push   %rbx
  802c15:	48 89 fb             	mov    %rdi,%rbx
  802c18:	48 89 f7             	mov    %rsi,%rdi
  802c1b:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802c1e:	48 85 f6             	test   %rsi,%rsi
  802c21:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c28:	00 00 00 
  802c2b:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802c2f:	be 00 10 00 00       	mov    $0x1000,%esi
  802c34:	48 b8 01 16 80 00 00 	movabs $0x801601,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	call   *%rax
    if (res < 0) {
  802c40:	85 c0                	test   %eax,%eax
  802c42:	78 45                	js     802c89 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802c44:	48 85 db             	test   %rbx,%rbx
  802c47:	74 12                	je     802c5b <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802c49:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  802c50:	00 00 00 
  802c53:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802c59:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802c5b:	4d 85 e4             	test   %r12,%r12
  802c5e:	74 14                	je     802c74 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802c60:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  802c67:	00 00 00 
  802c6a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c70:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802c74:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  802c7b:	00 00 00 
  802c7e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802c84:	5b                   	pop    %rbx
  802c85:	41 5c                	pop    %r12
  802c87:	5d                   	pop    %rbp
  802c88:	c3                   	ret
        if (from_env_store != NULL) {
  802c89:	48 85 db             	test   %rbx,%rbx
  802c8c:	74 06                	je     802c94 <ipc_recv+0x8a>
            *from_env_store = 0;
  802c8e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802c94:	4d 85 e4             	test   %r12,%r12
  802c97:	74 eb                	je     802c84 <ipc_recv+0x7a>
            *perm_store = 0;
  802c99:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ca0:	00 
  802ca1:	eb e1                	jmp    802c84 <ipc_recv+0x7a>

0000000000802ca3 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802ca3:	f3 0f 1e fa          	endbr64
  802ca7:	55                   	push   %rbp
  802ca8:	48 89 e5             	mov    %rsp,%rbp
  802cab:	41 57                	push   %r15
  802cad:	41 56                	push   %r14
  802caf:	41 55                	push   %r13
  802cb1:	41 54                	push   %r12
  802cb3:	53                   	push   %rbx
  802cb4:	48 83 ec 18          	sub    $0x18,%rsp
  802cb8:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802cbb:	48 89 d3             	mov    %rdx,%rbx
  802cbe:	49 89 cc             	mov    %rcx,%r12
  802cc1:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802cc4:	48 85 d2             	test   %rdx,%rdx
  802cc7:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802cce:	00 00 00 
  802cd1:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802cd5:	89 f0                	mov    %esi,%eax
  802cd7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802cdb:	48 89 da             	mov    %rbx,%rdx
  802cde:	48 89 c6             	mov    %rax,%rsi
  802ce1:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	call   *%rax
    while (res < 0) {
  802ced:	85 c0                	test   %eax,%eax
  802cef:	79 65                	jns    802d56 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802cf1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802cf4:	75 33                	jne    802d29 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802cf6:	49 bf 44 12 80 00 00 	movabs $0x801244,%r15
  802cfd:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802d00:	49 be d1 15 80 00 00 	movabs $0x8015d1,%r14
  802d07:	00 00 00 
        sys_yield();
  802d0a:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802d0d:	45 89 e8             	mov    %r13d,%r8d
  802d10:	4c 89 e1             	mov    %r12,%rcx
  802d13:	48 89 da             	mov    %rbx,%rdx
  802d16:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802d1a:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802d1d:	41 ff d6             	call   *%r14
    while (res < 0) {
  802d20:	85 c0                	test   %eax,%eax
  802d22:	79 32                	jns    802d56 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d24:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d27:	74 e1                	je     802d0a <ipc_send+0x67>
            panic("Error: %i\n", res);
  802d29:	89 c1                	mov    %eax,%ecx
  802d2b:	48 ba d7 33 80 00 00 	movabs $0x8033d7,%rdx
  802d32:	00 00 00 
  802d35:	be 42 00 00 00       	mov    $0x42,%esi
  802d3a:	48 bf e2 33 80 00 00 	movabs $0x8033e2,%rdi
  802d41:	00 00 00 
  802d44:	b8 00 00 00 00       	mov    $0x0,%eax
  802d49:	49 b8 35 02 80 00 00 	movabs $0x800235,%r8
  802d50:	00 00 00 
  802d53:	41 ff d0             	call   *%r8
    }
}
  802d56:	48 83 c4 18          	add    $0x18,%rsp
  802d5a:	5b                   	pop    %rbx
  802d5b:	41 5c                	pop    %r12
  802d5d:	41 5d                	pop    %r13
  802d5f:	41 5e                	pop    %r14
  802d61:	41 5f                	pop    %r15
  802d63:	5d                   	pop    %rbp
  802d64:	c3                   	ret

0000000000802d65 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802d65:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802d69:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802d6e:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802d75:	00 00 00 
  802d78:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d7c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d80:	48 c1 e2 04          	shl    $0x4,%rdx
  802d84:	48 01 ca             	add    %rcx,%rdx
  802d87:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d8d:	39 fa                	cmp    %edi,%edx
  802d8f:	74 12                	je     802da3 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802d91:	48 83 c0 01          	add    $0x1,%rax
  802d95:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d9b:	75 db                	jne    802d78 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da2:	c3                   	ret
            return envs[i].env_id;
  802da3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802da7:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802dab:	48 c1 e2 04          	shl    $0x4,%rdx
  802daf:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802db6:	00 00 00 
  802db9:	48 01 d0             	add    %rdx,%rax
  802dbc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dc2:	c3                   	ret

0000000000802dc3 <__text_end>:
  802dc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dca:	00 00 00 
  802dcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd4:	00 00 00 
  802dd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dde:	00 00 00 
  802de1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de8:	00 00 00 
  802deb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df2:	00 00 00 
  802df5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfc:	00 00 00 
  802dff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e06:	00 00 00 
  802e09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e10:	00 00 00 
  802e13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1a:	00 00 00 
  802e1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e24:	00 00 00 
  802e27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2e:	00 00 00 
  802e31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e38:	00 00 00 
  802e3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e42:	00 00 00 
  802e45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4c:	00 00 00 
  802e4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e56:	00 00 00 
  802e59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e60:	00 00 00 
  802e63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6a:	00 00 00 
  802e6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e74:	00 00 00 
  802e77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7e:	00 00 00 
  802e81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e88:	00 00 00 
  802e8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e92:	00 00 00 
  802e95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9c:	00 00 00 
  802e9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea6:	00 00 00 
  802ea9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb0:	00 00 00 
  802eb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eba:	00 00 00 
  802ebd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec4:	00 00 00 
  802ec7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ece:	00 00 00 
  802ed1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed8:	00 00 00 
  802edb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee2:	00 00 00 
  802ee5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eec:	00 00 00 
  802eef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef6:	00 00 00 
  802ef9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f00:	00 00 00 
  802f03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0a:	00 00 00 
  802f0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f14:	00 00 00 
  802f17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1e:	00 00 00 
  802f21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f28:	00 00 00 
  802f2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f32:	00 00 00 
  802f35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3c:	00 00 00 
  802f3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f46:	00 00 00 
  802f49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f50:	00 00 00 
  802f53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5a:	00 00 00 
  802f5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f64:	00 00 00 
  802f67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6e:	00 00 00 
  802f71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f78:	00 00 00 
  802f7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f82:	00 00 00 
  802f85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8c:	00 00 00 
  802f8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f96:	00 00 00 
  802f99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa0:	00 00 00 
  802fa3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802faa:	00 00 00 
  802fad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb4:	00 00 00 
  802fb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbe:	00 00 00 
  802fc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc8:	00 00 00 
  802fcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd2:	00 00 00 
  802fd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdc:	00 00 00 
  802fdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe6:	00 00 00 
  802fe9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff0:	00 00 00 
  802ff3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffa:	00 00 00 
  802ffd:	0f 1f 00             	nopl   (%rax)
