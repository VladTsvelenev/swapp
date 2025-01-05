
obj/user/faultalloc:     file format elf64-x86-64


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
  80001e:	e8 14 01 00 00       	call   800137 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <handler>:
/* Test user-level fault handler -- alloc pages to fix faults */

#include <inc/lib.h>

bool
handler(struct UTrapframe *utf) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
    int r;
    void *addr = (void *)utf->utf_fault_va;
  800032:	48 8b 1f             	mov    (%rdi),%rbx

    cprintf("fault %lx\n", (unsigned long)addr);
  800035:	48 89 de             	mov    %rbx,%rsi
  800038:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80003f:	00 00 00 
  800042:	b8 00 00 00 00       	mov    $0x0,%eax
  800047:	48 ba 6c 03 80 00 00 	movabs $0x80036c,%rdx
  80004e:	00 00 00 
  800051:	ff d2                	call   *%rdx
    if ((r = sys_alloc_region(0, ROUNDDOWN(addr, PAGE_SIZE),
  800053:	48 89 de             	mov    %rbx,%rsi
  800056:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  80005d:	b9 06 00 00 00       	mov    $0x6,%ecx
  800062:	ba 00 10 00 00       	mov    $0x1000,%edx
  800067:	bf 00 00 00 00       	mov    $0x0,%edi
  80006c:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  800073:	00 00 00 
  800076:	ff d0                	call   *%rax
  800078:	85 c0                	test   %eax,%eax
  80007a:	78 32                	js     8000ae <handler+0x89>
                              PAGE_SIZE, PROT_RW)) < 0)
        panic("allocating at %lx in page fault handler: %i", (unsigned long)addr, r);
    snprintf((char *)addr, 100, "this string was faulted in at %lx", (unsigned long)addr);
  80007c:	48 89 d9             	mov    %rbx,%rcx
  80007f:	48 ba e8 42 80 00 00 	movabs $0x8042e8,%rdx
  800086:	00 00 00 
  800089:	be 64 00 00 00       	mov    $0x64,%esi
  80008e:	48 89 df             	mov    %rbx,%rdi
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	49 b8 2f 0c 80 00 00 	movabs $0x800c2f,%r8
  80009d:	00 00 00 
  8000a0:	41 ff d0             	call   *%r8
    return 1;
}
  8000a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000a8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8000ac:	c9                   	leave
  8000ad:	c3                   	ret
        panic("allocating at %lx in page fault handler: %i", (unsigned long)addr, r);
  8000ae:	41 89 c0             	mov    %eax,%r8d
  8000b1:	48 89 d9             	mov    %rbx,%rcx
  8000b4:	48 ba b8 42 80 00 00 	movabs $0x8042b8,%rdx
  8000bb:	00 00 00 
  8000be:	be 0d 00 00 00       	mov    $0xd,%esi
  8000c3:	48 bf 0b 40 80 00 00 	movabs $0x80400b,%rdi
  8000ca:	00 00 00 
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  8000d9:	00 00 00 
  8000dc:	41 ff d1             	call   *%r9

00000000008000df <umain>:

void
umain(int argc, char **argv) {
  8000df:	f3 0f 1e fa          	endbr64
  8000e3:	55                   	push   %rbp
  8000e4:	48 89 e5             	mov    %rsp,%rbp
  8000e7:	41 54                	push   %r12
  8000e9:	53                   	push   %rbx
    add_pgfault_handler(handler);
  8000ea:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  8000f1:	00 00 00 
  8000f4:	48 b8 0c 17 80 00 00 	movabs $0x80170c,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	call   *%rax
    cprintf("%s\n", (char *)0xBeefDead);
  800100:	be ad de ef be       	mov    $0xbeefdead,%esi
  800105:	49 bc 1d 40 80 00 00 	movabs $0x80401d,%r12
  80010c:	00 00 00 
  80010f:	4c 89 e7             	mov    %r12,%rdi
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 bb 6c 03 80 00 00 	movabs $0x80036c,%rbx
  80011e:	00 00 00 
  800121:	ff d3                	call   *%rbx
    cprintf("%s\n", (char *)0xCafeBffe);
  800123:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800128:	4c 89 e7             	mov    %r12,%rdi
  80012b:	b8 00 00 00 00       	mov    $0x0,%eax
  800130:	ff d3                	call   *%rbx
}
  800132:	5b                   	pop    %rbx
  800133:	41 5c                	pop    %r12
  800135:	5d                   	pop    %rbp
  800136:	c3                   	ret

0000000000800137 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800137:	f3 0f 1e fa          	endbr64
  80013b:	55                   	push   %rbp
  80013c:	48 89 e5             	mov    %rsp,%rbp
  80013f:	41 56                	push   %r14
  800141:	41 55                	push   %r13
  800143:	41 54                	push   %r12
  800145:	53                   	push   %rbx
  800146:	41 89 fd             	mov    %edi,%r13d
  800149:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80014c:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800153:	00 00 00 
  800156:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80015d:	00 00 00 
  800160:	48 39 c2             	cmp    %rax,%rdx
  800163:	73 17                	jae    80017c <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800165:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800168:	49 89 c4             	mov    %rax,%r12
  80016b:	48 83 c3 08          	add    $0x8,%rbx
  80016f:	b8 00 00 00 00       	mov    $0x0,%eax
  800174:	ff 53 f8             	call   *-0x8(%rbx)
  800177:	4c 39 e3             	cmp    %r12,%rbx
  80017a:	72 ef                	jb     80016b <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80017c:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  800183:	00 00 00 
  800186:	ff d0                	call   *%rax
  800188:	25 ff 03 00 00       	and    $0x3ff,%eax
  80018d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800191:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800195:	48 c1 e0 04          	shl    $0x4,%rax
  800199:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001a0:	00 00 00 
  8001a3:	48 01 d0             	add    %rdx,%rax
  8001a6:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8001ad:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001b0:	45 85 ed             	test   %r13d,%r13d
  8001b3:	7e 0d                	jle    8001c2 <libmain+0x8b>
  8001b5:	49 8b 06             	mov    (%r14),%rax
  8001b8:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001bf:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001c2:	4c 89 f6             	mov    %r14,%rsi
  8001c5:	44 89 ef             	mov    %r13d,%edi
  8001c8:	48 b8 df 00 80 00 00 	movabs $0x8000df,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001d4:	48 b8 e9 01 80 00 00 	movabs $0x8001e9,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	call   *%rax
#endif
}
  8001e0:	5b                   	pop    %rbx
  8001e1:	41 5c                	pop    %r12
  8001e3:	41 5d                	pop    %r13
  8001e5:	41 5e                	pop    %r14
  8001e7:	5d                   	pop    %rbp
  8001e8:	c3                   	ret

00000000008001e9 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001e9:	f3 0f 1e fa          	endbr64
  8001ed:	55                   	push   %rbp
  8001ee:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001f1:	48 b8 d4 1b 80 00 00 	movabs $0x801bd4,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800202:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  800209:	00 00 00 
  80020c:	ff d0                	call   *%rax
}
  80020e:	5d                   	pop    %rbp
  80020f:	c3                   	ret

0000000000800210 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800210:	f3 0f 1e fa          	endbr64
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
  800218:	41 56                	push   %r14
  80021a:	41 55                	push   %r13
  80021c:	41 54                	push   %r12
  80021e:	53                   	push   %rbx
  80021f:	48 83 ec 50          	sub    $0x50,%rsp
  800223:	49 89 fc             	mov    %rdi,%r12
  800226:	41 89 f5             	mov    %esi,%r13d
  800229:	48 89 d3             	mov    %rdx,%rbx
  80022c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800230:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800234:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800238:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80023f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800243:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800247:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80024b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80024f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800256:	00 00 00 
  800259:	4c 8b 30             	mov    (%rax),%r14
  80025c:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  800263:	00 00 00 
  800266:	ff d0                	call   *%rax
  800268:	89 c6                	mov    %eax,%esi
  80026a:	45 89 e8             	mov    %r13d,%r8d
  80026d:	4c 89 e1             	mov    %r12,%rcx
  800270:	4c 89 f2             	mov    %r14,%rdx
  800273:	48 bf 10 43 80 00 00 	movabs $0x804310,%rdi
  80027a:	00 00 00 
  80027d:	b8 00 00 00 00       	mov    $0x0,%eax
  800282:	49 bc 6c 03 80 00 00 	movabs $0x80036c,%r12
  800289:	00 00 00 
  80028c:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80028f:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800293:	48 89 df             	mov    %rbx,%rdi
  800296:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	call   *%rax
    cprintf("\n");
  8002a2:	48 bf 37 42 80 00 00 	movabs $0x804237,%rdi
  8002a9:	00 00 00 
  8002ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b1:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002b4:	cc                   	int3
  8002b5:	eb fd                	jmp    8002b4 <_panic+0xa4>

00000000008002b7 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002b7:	f3 0f 1e fa          	endbr64
  8002bb:	55                   	push   %rbp
  8002bc:	48 89 e5             	mov    %rsp,%rbp
  8002bf:	53                   	push   %rbx
  8002c0:	48 83 ec 08          	sub    $0x8,%rsp
  8002c4:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002c7:	8b 06                	mov    (%rsi),%eax
  8002c9:	8d 50 01             	lea    0x1(%rax),%edx
  8002cc:	89 16                	mov    %edx,(%rsi)
  8002ce:	48 98                	cltq
  8002d0:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002d5:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002db:	74 0a                	je     8002e7 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8002dd:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8002e1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002e5:	c9                   	leave
  8002e6:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8002e7:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002eb:	be ff 00 00 00       	mov    $0xff,%esi
  8002f0:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  8002f7:	00 00 00 
  8002fa:	ff d0                	call   *%rax
        state->offset = 0;
  8002fc:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800302:	eb d9                	jmp    8002dd <putch+0x26>

0000000000800304 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800304:	f3 0f 1e fa          	endbr64
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
  80030c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800313:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800316:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80031d:	b9 21 00 00 00       	mov    $0x21,%ecx
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80032a:	48 89 f1             	mov    %rsi,%rcx
  80032d:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800334:	48 bf b7 02 80 00 00 	movabs $0x8002b7,%rdi
  80033b:	00 00 00 
  80033e:	48 b8 cc 04 80 00 00 	movabs $0x8004cc,%rax
  800345:	00 00 00 
  800348:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80034a:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800351:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800358:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  80035f:	00 00 00 
  800362:	ff d0                	call   *%rax

    return state.count;
}
  800364:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80036a:	c9                   	leave
  80036b:	c3                   	ret

000000000080036c <cprintf>:

int
cprintf(const char *fmt, ...) {
  80036c:	f3 0f 1e fa          	endbr64
  800370:	55                   	push   %rbp
  800371:	48 89 e5             	mov    %rsp,%rbp
  800374:	48 83 ec 50          	sub    $0x50,%rsp
  800378:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80037c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800380:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800384:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800388:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80038c:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800393:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800397:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80039b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80039f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003a3:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8003a7:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  8003ae:	00 00 00 
  8003b1:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8003b3:	c9                   	leave
  8003b4:	c3                   	ret

00000000008003b5 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8003b5:	f3 0f 1e fa          	endbr64
  8003b9:	55                   	push   %rbp
  8003ba:	48 89 e5             	mov    %rsp,%rbp
  8003bd:	41 57                	push   %r15
  8003bf:	41 56                	push   %r14
  8003c1:	41 55                	push   %r13
  8003c3:	41 54                	push   %r12
  8003c5:	53                   	push   %rbx
  8003c6:	48 83 ec 18          	sub    $0x18,%rsp
  8003ca:	49 89 fc             	mov    %rdi,%r12
  8003cd:	49 89 f5             	mov    %rsi,%r13
  8003d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003d4:	8b 45 10             	mov    0x10(%rbp),%eax
  8003d7:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003da:	41 89 cf             	mov    %ecx,%r15d
  8003dd:	4c 39 fa             	cmp    %r15,%rdx
  8003e0:	73 5b                	jae    80043d <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8003e2:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8003e6:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003ea:	85 db                	test   %ebx,%ebx
  8003ec:	7e 0e                	jle    8003fc <print_num+0x47>
            putch(padc, put_arg);
  8003ee:	4c 89 ee             	mov    %r13,%rsi
  8003f1:	44 89 f7             	mov    %r14d,%edi
  8003f4:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003f7:	83 eb 01             	sub    $0x1,%ebx
  8003fa:	75 f2                	jne    8003ee <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8003fc:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800400:	48 b9 3c 40 80 00 00 	movabs $0x80403c,%rcx
  800407:	00 00 00 
  80040a:	48 b8 2b 40 80 00 00 	movabs $0x80402b,%rax
  800411:	00 00 00 
  800414:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800418:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80041c:	ba 00 00 00 00       	mov    $0x0,%edx
  800421:	49 f7 f7             	div    %r15
  800424:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800428:	4c 89 ee             	mov    %r13,%rsi
  80042b:	41 ff d4             	call   *%r12
}
  80042e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800432:	5b                   	pop    %rbx
  800433:	41 5c                	pop    %r12
  800435:	41 5d                	pop    %r13
  800437:	41 5e                	pop    %r14
  800439:	41 5f                	pop    %r15
  80043b:	5d                   	pop    %rbp
  80043c:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80043d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	49 f7 f7             	div    %r15
  800449:	48 83 ec 08          	sub    $0x8,%rsp
  80044d:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800451:	52                   	push   %rdx
  800452:	45 0f be c9          	movsbl %r9b,%r9d
  800456:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80045a:	48 89 c2             	mov    %rax,%rdx
  80045d:	48 b8 b5 03 80 00 00 	movabs $0x8003b5,%rax
  800464:	00 00 00 
  800467:	ff d0                	call   *%rax
  800469:	48 83 c4 10          	add    $0x10,%rsp
  80046d:	eb 8d                	jmp    8003fc <print_num+0x47>

000000000080046f <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80046f:	f3 0f 1e fa          	endbr64
    state->count++;
  800473:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800477:	48 8b 06             	mov    (%rsi),%rax
  80047a:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80047e:	73 0a                	jae    80048a <sprintputch+0x1b>
        *state->start++ = ch;
  800480:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800484:	48 89 16             	mov    %rdx,(%rsi)
  800487:	40 88 38             	mov    %dil,(%rax)
    }
}
  80048a:	c3                   	ret

000000000080048b <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80048b:	f3 0f 1e fa          	endbr64
  80048f:	55                   	push   %rbp
  800490:	48 89 e5             	mov    %rsp,%rbp
  800493:	48 83 ec 50          	sub    $0x50,%rsp
  800497:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80049b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80049f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004a3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004b2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004b6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8004ba:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8004be:	48 b8 cc 04 80 00 00 	movabs $0x8004cc,%rax
  8004c5:	00 00 00 
  8004c8:	ff d0                	call   *%rax
}
  8004ca:	c9                   	leave
  8004cb:	c3                   	ret

00000000008004cc <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004cc:	f3 0f 1e fa          	endbr64
  8004d0:	55                   	push   %rbp
  8004d1:	48 89 e5             	mov    %rsp,%rbp
  8004d4:	41 57                	push   %r15
  8004d6:	41 56                	push   %r14
  8004d8:	41 55                	push   %r13
  8004da:	41 54                	push   %r12
  8004dc:	53                   	push   %rbx
  8004dd:	48 83 ec 38          	sub    $0x38,%rsp
  8004e1:	49 89 fe             	mov    %rdi,%r14
  8004e4:	49 89 f5             	mov    %rsi,%r13
  8004e7:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8004ea:	48 8b 01             	mov    (%rcx),%rax
  8004ed:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004f1:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004f5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004f9:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004fd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800501:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800505:	0f b6 3b             	movzbl (%rbx),%edi
  800508:	40 80 ff 25          	cmp    $0x25,%dil
  80050c:	74 18                	je     800526 <vprintfmt+0x5a>
            if (!ch) return;
  80050e:	40 84 ff             	test   %dil,%dil
  800511:	0f 84 b2 06 00 00    	je     800bc9 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800517:	40 0f b6 ff          	movzbl %dil,%edi
  80051b:	4c 89 ee             	mov    %r13,%rsi
  80051e:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800521:	4c 89 e3             	mov    %r12,%rbx
  800524:	eb db                	jmp    800501 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800526:	be 00 00 00 00       	mov    $0x0,%esi
  80052b:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800534:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80053a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800541:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800545:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80054a:	41 0f b6 04 24       	movzbl (%r12),%eax
  80054f:	88 45 a0             	mov    %al,-0x60(%rbp)
  800552:	83 e8 23             	sub    $0x23,%eax
  800555:	3c 57                	cmp    $0x57,%al
  800557:	0f 87 52 06 00 00    	ja     800baf <vprintfmt+0x6e3>
  80055d:	0f b6 c0             	movzbl %al,%eax
  800560:	48 b9 20 44 80 00 00 	movabs $0x804420,%rcx
  800567:	00 00 00 
  80056a:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80056e:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800571:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800575:	eb ce                	jmp    800545 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800577:	49 89 dc             	mov    %rbx,%r12
  80057a:	be 01 00 00 00       	mov    $0x1,%esi
  80057f:	eb c4                	jmp    800545 <vprintfmt+0x79>
            padc = ch;
  800581:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800585:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800588:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80058b:	eb b8                	jmp    800545 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80058d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800590:	83 f8 2f             	cmp    $0x2f,%eax
  800593:	77 24                	ja     8005b9 <vprintfmt+0xed>
  800595:	89 c1                	mov    %eax,%ecx
  800597:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80059b:	83 c0 08             	add    $0x8,%eax
  80059e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005a1:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8005a4:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8005a7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005ab:	79 98                	jns    800545 <vprintfmt+0x79>
                width = precision;
  8005ad:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8005b1:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005b7:	eb 8c                	jmp    800545 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8005b9:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8005bd:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8005c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c5:	eb da                	jmp    8005a1 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8005c7:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8005cc:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005d0:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8005d6:	3c 39                	cmp    $0x39,%al
  8005d8:	77 1c                	ja     8005f6 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8005da:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8005de:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8005e2:	0f b6 c0             	movzbl %al,%eax
  8005e5:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005ea:	0f b6 03             	movzbl (%rbx),%eax
  8005ed:	3c 39                	cmp    $0x39,%al
  8005ef:	76 e9                	jbe    8005da <vprintfmt+0x10e>
        process_precision:
  8005f1:	49 89 dc             	mov    %rbx,%r12
  8005f4:	eb b1                	jmp    8005a7 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8005f6:	49 89 dc             	mov    %rbx,%r12
  8005f9:	eb ac                	jmp    8005a7 <vprintfmt+0xdb>
            width = MAX(0, width);
  8005fb:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8005fe:	85 c9                	test   %ecx,%ecx
  800600:	b8 00 00 00 00       	mov    $0x0,%eax
  800605:	0f 49 c1             	cmovns %ecx,%eax
  800608:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80060b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80060e:	e9 32 ff ff ff       	jmp    800545 <vprintfmt+0x79>
            lflag++;
  800613:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800616:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800619:	e9 27 ff ff ff       	jmp    800545 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80061e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800621:	83 f8 2f             	cmp    $0x2f,%eax
  800624:	77 19                	ja     80063f <vprintfmt+0x173>
  800626:	89 c2                	mov    %eax,%edx
  800628:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80062c:	83 c0 08             	add    $0x8,%eax
  80062f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800632:	8b 3a                	mov    (%rdx),%edi
  800634:	4c 89 ee             	mov    %r13,%rsi
  800637:	41 ff d6             	call   *%r14
            break;
  80063a:	e9 c2 fe ff ff       	jmp    800501 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80063f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800643:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800647:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80064b:	eb e5                	jmp    800632 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80064d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800650:	83 f8 2f             	cmp    $0x2f,%eax
  800653:	77 5a                	ja     8006af <vprintfmt+0x1e3>
  800655:	89 c2                	mov    %eax,%edx
  800657:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80065b:	83 c0 08             	add    $0x8,%eax
  80065e:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800661:	8b 02                	mov    (%rdx),%eax
  800663:	89 c1                	mov    %eax,%ecx
  800665:	f7 d9                	neg    %ecx
  800667:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80066a:	83 f9 13             	cmp    $0x13,%ecx
  80066d:	7f 4e                	jg     8006bd <vprintfmt+0x1f1>
  80066f:	48 63 c1             	movslq %ecx,%rax
  800672:	48 ba e0 46 80 00 00 	movabs $0x8046e0,%rdx
  800679:	00 00 00 
  80067c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800680:	48 85 c0             	test   %rax,%rax
  800683:	74 38                	je     8006bd <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800685:	48 89 c1             	mov    %rax,%rcx
  800688:	48 ba 1a 42 80 00 00 	movabs $0x80421a,%rdx
  80068f:	00 00 00 
  800692:	4c 89 ee             	mov    %r13,%rsi
  800695:	4c 89 f7             	mov    %r14,%rdi
  800698:	b8 00 00 00 00       	mov    $0x0,%eax
  80069d:	49 b8 8b 04 80 00 00 	movabs $0x80048b,%r8
  8006a4:	00 00 00 
  8006a7:	41 ff d0             	call   *%r8
  8006aa:	e9 52 fe ff ff       	jmp    800501 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8006af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006b3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006bb:	eb a4                	jmp    800661 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8006bd:	48 ba 54 40 80 00 00 	movabs $0x804054,%rdx
  8006c4:	00 00 00 
  8006c7:	4c 89 ee             	mov    %r13,%rsi
  8006ca:	4c 89 f7             	mov    %r14,%rdi
  8006cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d2:	49 b8 8b 04 80 00 00 	movabs $0x80048b,%r8
  8006d9:	00 00 00 
  8006dc:	41 ff d0             	call   *%r8
  8006df:	e9 1d fe ff ff       	jmp    800501 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e7:	83 f8 2f             	cmp    $0x2f,%eax
  8006ea:	77 6c                	ja     800758 <vprintfmt+0x28c>
  8006ec:	89 c2                	mov    %eax,%edx
  8006ee:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006f2:	83 c0 08             	add    $0x8,%eax
  8006f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006f8:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8006fb:	48 85 d2             	test   %rdx,%rdx
  8006fe:	48 b8 4d 40 80 00 00 	movabs $0x80404d,%rax
  800705:	00 00 00 
  800708:	48 0f 45 c2          	cmovne %rdx,%rax
  80070c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800710:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800714:	7e 06                	jle    80071c <vprintfmt+0x250>
  800716:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80071a:	75 4a                	jne    800766 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80071c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800720:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800724:	0f b6 00             	movzbl (%rax),%eax
  800727:	84 c0                	test   %al,%al
  800729:	0f 85 9a 00 00 00    	jne    8007c9 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80072f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800732:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800736:	85 c0                	test   %eax,%eax
  800738:	0f 8e c3 fd ff ff    	jle    800501 <vprintfmt+0x35>
  80073e:	4c 89 ee             	mov    %r13,%rsi
  800741:	bf 20 00 00 00       	mov    $0x20,%edi
  800746:	41 ff d6             	call   *%r14
  800749:	41 83 ec 01          	sub    $0x1,%r12d
  80074d:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800751:	75 eb                	jne    80073e <vprintfmt+0x272>
  800753:	e9 a9 fd ff ff       	jmp    800501 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800758:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80075c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800760:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800764:	eb 92                	jmp    8006f8 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800766:	49 63 f7             	movslq %r15d,%rsi
  800769:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80076d:	48 b8 8f 0c 80 00 00 	movabs $0x800c8f,%rax
  800774:	00 00 00 
  800777:	ff d0                	call   *%rax
  800779:	48 89 c2             	mov    %rax,%rdx
  80077c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80077f:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800781:	8d 70 ff             	lea    -0x1(%rax),%esi
  800784:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800787:	85 c0                	test   %eax,%eax
  800789:	7e 91                	jle    80071c <vprintfmt+0x250>
  80078b:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800790:	4c 89 ee             	mov    %r13,%rsi
  800793:	44 89 e7             	mov    %r12d,%edi
  800796:	41 ff d6             	call   *%r14
  800799:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80079d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007a0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8007a3:	75 eb                	jne    800790 <vprintfmt+0x2c4>
  8007a5:	e9 72 ff ff ff       	jmp    80071c <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007aa:	0f b6 f8             	movzbl %al,%edi
  8007ad:	4c 89 ee             	mov    %r13,%rsi
  8007b0:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007b3:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8007b7:	49 83 c4 01          	add    $0x1,%r12
  8007bb:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8007c1:	84 c0                	test   %al,%al
  8007c3:	0f 84 66 ff ff ff    	je     80072f <vprintfmt+0x263>
  8007c9:	45 85 ff             	test   %r15d,%r15d
  8007cc:	78 0a                	js     8007d8 <vprintfmt+0x30c>
  8007ce:	41 83 ef 01          	sub    $0x1,%r15d
  8007d2:	0f 88 57 ff ff ff    	js     80072f <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007d8:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8007dc:	74 cc                	je     8007aa <vprintfmt+0x2de>
  8007de:	8d 50 e0             	lea    -0x20(%rax),%edx
  8007e1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8007e6:	80 fa 5e             	cmp    $0x5e,%dl
  8007e9:	77 c2                	ja     8007ad <vprintfmt+0x2e1>
  8007eb:	eb bd                	jmp    8007aa <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8007ed:	40 84 f6             	test   %sil,%sil
  8007f0:	75 26                	jne    800818 <vprintfmt+0x34c>
    switch (lflag) {
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	74 59                	je     80084f <vprintfmt+0x383>
  8007f6:	83 fa 01             	cmp    $0x1,%edx
  8007f9:	74 7b                	je     800876 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8007fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fe:	83 f8 2f             	cmp    $0x2f,%eax
  800801:	0f 87 96 00 00 00    	ja     80089d <vprintfmt+0x3d1>
  800807:	89 c2                	mov    %eax,%edx
  800809:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80080d:	83 c0 08             	add    $0x8,%eax
  800810:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800813:	4c 8b 22             	mov    (%rdx),%r12
  800816:	eb 17                	jmp    80082f <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800818:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081b:	83 f8 2f             	cmp    $0x2f,%eax
  80081e:	77 21                	ja     800841 <vprintfmt+0x375>
  800820:	89 c2                	mov    %eax,%edx
  800822:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800826:	83 c0 08             	add    $0x8,%eax
  800829:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80082c:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80082f:	4d 85 e4             	test   %r12,%r12
  800832:	78 7a                	js     8008ae <vprintfmt+0x3e2>
            num = i;
  800834:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800837:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80083c:	e9 50 02 00 00       	jmp    800a91 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800841:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800845:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800849:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80084d:	eb dd                	jmp    80082c <vprintfmt+0x360>
        return va_arg(*ap, int);
  80084f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800852:	83 f8 2f             	cmp    $0x2f,%eax
  800855:	77 11                	ja     800868 <vprintfmt+0x39c>
  800857:	89 c2                	mov    %eax,%edx
  800859:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80085d:	83 c0 08             	add    $0x8,%eax
  800860:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800863:	4c 63 22             	movslq (%rdx),%r12
  800866:	eb c7                	jmp    80082f <vprintfmt+0x363>
  800868:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800870:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800874:	eb ed                	jmp    800863 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800876:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800879:	83 f8 2f             	cmp    $0x2f,%eax
  80087c:	77 11                	ja     80088f <vprintfmt+0x3c3>
  80087e:	89 c2                	mov    %eax,%edx
  800880:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800884:	83 c0 08             	add    $0x8,%eax
  800887:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088a:	4c 8b 22             	mov    (%rdx),%r12
  80088d:	eb a0                	jmp    80082f <vprintfmt+0x363>
  80088f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800893:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800897:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80089b:	eb ed                	jmp    80088a <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80089d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a9:	e9 65 ff ff ff       	jmp    800813 <vprintfmt+0x347>
                putch('-', put_arg);
  8008ae:	4c 89 ee             	mov    %r13,%rsi
  8008b1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8008b6:	41 ff d6             	call   *%r14
                i = -i;
  8008b9:	49 f7 dc             	neg    %r12
  8008bc:	e9 73 ff ff ff       	jmp    800834 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8008c1:	40 84 f6             	test   %sil,%sil
  8008c4:	75 32                	jne    8008f8 <vprintfmt+0x42c>
    switch (lflag) {
  8008c6:	85 d2                	test   %edx,%edx
  8008c8:	74 5d                	je     800927 <vprintfmt+0x45b>
  8008ca:	83 fa 01             	cmp    $0x1,%edx
  8008cd:	0f 84 82 00 00 00    	je     800955 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8008d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d6:	83 f8 2f             	cmp    $0x2f,%eax
  8008d9:	0f 87 a5 00 00 00    	ja     800984 <vprintfmt+0x4b8>
  8008df:	89 c2                	mov    %eax,%edx
  8008e1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008e5:	83 c0 08             	add    $0x8,%eax
  8008e8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008eb:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8008f3:	e9 99 01 00 00       	jmp    800a91 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fb:	83 f8 2f             	cmp    $0x2f,%eax
  8008fe:	77 19                	ja     800919 <vprintfmt+0x44d>
  800900:	89 c2                	mov    %eax,%edx
  800902:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800906:	83 c0 08             	add    $0x8,%eax
  800909:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80090f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800914:	e9 78 01 00 00       	jmp    800a91 <vprintfmt+0x5c5>
  800919:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800921:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800925:	eb e5                	jmp    80090c <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800927:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092a:	83 f8 2f             	cmp    $0x2f,%eax
  80092d:	77 18                	ja     800947 <vprintfmt+0x47b>
  80092f:	89 c2                	mov    %eax,%edx
  800931:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800935:	83 c0 08             	add    $0x8,%eax
  800938:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80093b:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80093d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800942:	e9 4a 01 00 00       	jmp    800a91 <vprintfmt+0x5c5>
  800947:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80094f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800953:	eb e6                	jmp    80093b <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800955:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800958:	83 f8 2f             	cmp    $0x2f,%eax
  80095b:	77 19                	ja     800976 <vprintfmt+0x4aa>
  80095d:	89 c2                	mov    %eax,%edx
  80095f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800963:	83 c0 08             	add    $0x8,%eax
  800966:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800969:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80096c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800971:	e9 1b 01 00 00       	jmp    800a91 <vprintfmt+0x5c5>
  800976:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80097e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800982:	eb e5                	jmp    800969 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800984:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800988:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80098c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800990:	e9 56 ff ff ff       	jmp    8008eb <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800995:	40 84 f6             	test   %sil,%sil
  800998:	75 2e                	jne    8009c8 <vprintfmt+0x4fc>
    switch (lflag) {
  80099a:	85 d2                	test   %edx,%edx
  80099c:	74 59                	je     8009f7 <vprintfmt+0x52b>
  80099e:	83 fa 01             	cmp    $0x1,%edx
  8009a1:	74 7f                	je     800a22 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8009a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a6:	83 f8 2f             	cmp    $0x2f,%eax
  8009a9:	0f 87 9f 00 00 00    	ja     800a4e <vprintfmt+0x582>
  8009af:	89 c2                	mov    %eax,%edx
  8009b1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b5:	83 c0 08             	add    $0x8,%eax
  8009b8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009bb:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009be:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009c3:	e9 c9 00 00 00       	jmp    800a91 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cb:	83 f8 2f             	cmp    $0x2f,%eax
  8009ce:	77 19                	ja     8009e9 <vprintfmt+0x51d>
  8009d0:	89 c2                	mov    %eax,%edx
  8009d2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d6:	83 c0 08             	add    $0x8,%eax
  8009d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009dc:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009df:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009e4:	e9 a8 00 00 00       	jmp    800a91 <vprintfmt+0x5c5>
  8009e9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f5:	eb e5                	jmp    8009dc <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8009f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fa:	83 f8 2f             	cmp    $0x2f,%eax
  8009fd:	77 15                	ja     800a14 <vprintfmt+0x548>
  8009ff:	89 c2                	mov    %eax,%edx
  800a01:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a05:	83 c0 08             	add    $0x8,%eax
  800a08:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a0b:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800a0d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a12:	eb 7d                	jmp    800a91 <vprintfmt+0x5c5>
  800a14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a18:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a1c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a20:	eb e9                	jmp    800a0b <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a25:	83 f8 2f             	cmp    $0x2f,%eax
  800a28:	77 16                	ja     800a40 <vprintfmt+0x574>
  800a2a:	89 c2                	mov    %eax,%edx
  800a2c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a30:	83 c0 08             	add    $0x8,%eax
  800a33:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a36:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a39:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a3e:	eb 51                	jmp    800a91 <vprintfmt+0x5c5>
  800a40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a44:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a4c:	eb e8                	jmp    800a36 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800a4e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a52:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a56:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a5a:	e9 5c ff ff ff       	jmp    8009bb <vprintfmt+0x4ef>
            putch('0', put_arg);
  800a5f:	4c 89 ee             	mov    %r13,%rsi
  800a62:	bf 30 00 00 00       	mov    $0x30,%edi
  800a67:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800a6a:	4c 89 ee             	mov    %r13,%rsi
  800a6d:	bf 78 00 00 00       	mov    $0x78,%edi
  800a72:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a78:	83 f8 2f             	cmp    $0x2f,%eax
  800a7b:	77 47                	ja     800ac4 <vprintfmt+0x5f8>
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a83:	83 c0 08             	add    $0x8,%eax
  800a86:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a89:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a8c:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a91:	48 83 ec 08          	sub    $0x8,%rsp
  800a95:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800a99:	0f 94 c0             	sete   %al
  800a9c:	0f b6 c0             	movzbl %al,%eax
  800a9f:	50                   	push   %rax
  800aa0:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800aa5:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800aa9:	4c 89 ee             	mov    %r13,%rsi
  800aac:	4c 89 f7             	mov    %r14,%rdi
  800aaf:	48 b8 b5 03 80 00 00 	movabs $0x8003b5,%rax
  800ab6:	00 00 00 
  800ab9:	ff d0                	call   *%rax
            break;
  800abb:	48 83 c4 10          	add    $0x10,%rsp
  800abf:	e9 3d fa ff ff       	jmp    800501 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800ac4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800acc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad0:	eb b7                	jmp    800a89 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800ad2:	40 84 f6             	test   %sil,%sil
  800ad5:	75 2b                	jne    800b02 <vprintfmt+0x636>
    switch (lflag) {
  800ad7:	85 d2                	test   %edx,%edx
  800ad9:	74 56                	je     800b31 <vprintfmt+0x665>
  800adb:	83 fa 01             	cmp    $0x1,%edx
  800ade:	74 7f                	je     800b5f <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	83 f8 2f             	cmp    $0x2f,%eax
  800ae6:	0f 87 a2 00 00 00    	ja     800b8e <vprintfmt+0x6c2>
  800aec:	89 c2                	mov    %eax,%edx
  800aee:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800af2:	83 c0 08             	add    $0x8,%eax
  800af5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af8:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800afb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b00:	eb 8f                	jmp    800a91 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b05:	83 f8 2f             	cmp    $0x2f,%eax
  800b08:	77 19                	ja     800b23 <vprintfmt+0x657>
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b10:	83 c0 08             	add    $0x8,%eax
  800b13:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b16:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b19:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b1e:	e9 6e ff ff ff       	jmp    800a91 <vprintfmt+0x5c5>
  800b23:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b27:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b2b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2f:	eb e5                	jmp    800b16 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800b31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b34:	83 f8 2f             	cmp    $0x2f,%eax
  800b37:	77 18                	ja     800b51 <vprintfmt+0x685>
  800b39:	89 c2                	mov    %eax,%edx
  800b3b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b3f:	83 c0 08             	add    $0x8,%eax
  800b42:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b45:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800b47:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b4c:	e9 40 ff ff ff       	jmp    800a91 <vprintfmt+0x5c5>
  800b51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b55:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b5d:	eb e6                	jmp    800b45 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800b5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b62:	83 f8 2f             	cmp    $0x2f,%eax
  800b65:	77 19                	ja     800b80 <vprintfmt+0x6b4>
  800b67:	89 c2                	mov    %eax,%edx
  800b69:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b6d:	83 c0 08             	add    $0x8,%eax
  800b70:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b73:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b76:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b7b:	e9 11 ff ff ff       	jmp    800a91 <vprintfmt+0x5c5>
  800b80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b84:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b88:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b8c:	eb e5                	jmp    800b73 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800b8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b92:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b9a:	e9 59 ff ff ff       	jmp    800af8 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800b9f:	4c 89 ee             	mov    %r13,%rsi
  800ba2:	bf 25 00 00 00       	mov    $0x25,%edi
  800ba7:	41 ff d6             	call   *%r14
            break;
  800baa:	e9 52 f9 ff ff       	jmp    800501 <vprintfmt+0x35>
            putch('%', put_arg);
  800baf:	4c 89 ee             	mov    %r13,%rsi
  800bb2:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb7:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800bba:	48 83 eb 01          	sub    $0x1,%rbx
  800bbe:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800bc2:	75 f6                	jne    800bba <vprintfmt+0x6ee>
  800bc4:	e9 38 f9 ff ff       	jmp    800501 <vprintfmt+0x35>
}
  800bc9:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800bcd:	5b                   	pop    %rbx
  800bce:	41 5c                	pop    %r12
  800bd0:	41 5d                	pop    %r13
  800bd2:	41 5e                	pop    %r14
  800bd4:	41 5f                	pop    %r15
  800bd6:	5d                   	pop    %rbp
  800bd7:	c3                   	ret

0000000000800bd8 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bd8:	f3 0f 1e fa          	endbr64
  800bdc:	55                   	push   %rbp
  800bdd:	48 89 e5             	mov    %rsp,%rbp
  800be0:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800be4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800be8:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800bed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800bf1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800bf8:	48 85 ff             	test   %rdi,%rdi
  800bfb:	74 2b                	je     800c28 <vsnprintf+0x50>
  800bfd:	48 85 f6             	test   %rsi,%rsi
  800c00:	74 26                	je     800c28 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c02:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c06:	48 bf 6f 04 80 00 00 	movabs $0x80046f,%rdi
  800c0d:	00 00 00 
  800c10:	48 b8 cc 04 80 00 00 	movabs $0x8004cc,%rax
  800c17:	00 00 00 
  800c1a:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c20:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c23:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c26:	c9                   	leave
  800c27:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800c28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c2d:	eb f7                	jmp    800c26 <vsnprintf+0x4e>

0000000000800c2f <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c2f:	f3 0f 1e fa          	endbr64
  800c33:	55                   	push   %rbp
  800c34:	48 89 e5             	mov    %rsp,%rbp
  800c37:	48 83 ec 50          	sub    $0x50,%rsp
  800c3b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c3f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c43:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c47:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c52:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c56:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c5a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c5e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c62:	48 b8 d8 0b 80 00 00 	movabs $0x800bd8,%rax
  800c69:	00 00 00 
  800c6c:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c6e:	c9                   	leave
  800c6f:	c3                   	ret

0000000000800c70 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800c70:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c74:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c77:	74 10                	je     800c89 <strlen+0x19>
    size_t n = 0;
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c7e:	48 83 c0 01          	add    $0x1,%rax
  800c82:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c86:	75 f6                	jne    800c7e <strlen+0xe>
  800c88:	c3                   	ret
    size_t n = 0;
  800c89:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c8e:	c3                   	ret

0000000000800c8f <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800c8f:	f3 0f 1e fa          	endbr64
  800c93:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800c9b:	48 85 f6             	test   %rsi,%rsi
  800c9e:	74 10                	je     800cb0 <strnlen+0x21>
  800ca0:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800ca4:	74 0b                	je     800cb1 <strnlen+0x22>
  800ca6:	48 83 c2 01          	add    $0x1,%rdx
  800caa:	48 39 d0             	cmp    %rdx,%rax
  800cad:	75 f1                	jne    800ca0 <strnlen+0x11>
  800caf:	c3                   	ret
  800cb0:	c3                   	ret
  800cb1:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800cb4:	c3                   	ret

0000000000800cb5 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800cb5:	f3 0f 1e fa          	endbr64
  800cb9:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc1:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800cc5:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800cc8:	48 83 c2 01          	add    $0x1,%rdx
  800ccc:	84 c9                	test   %cl,%cl
  800cce:	75 f1                	jne    800cc1 <strcpy+0xc>
        ;
    return res;
}
  800cd0:	c3                   	ret

0000000000800cd1 <strcat>:

char *
strcat(char *dst, const char *src) {
  800cd1:	f3 0f 1e fa          	endbr64
  800cd5:	55                   	push   %rbp
  800cd6:	48 89 e5             	mov    %rsp,%rbp
  800cd9:	41 54                	push   %r12
  800cdb:	53                   	push   %rbx
  800cdc:	48 89 fb             	mov    %rdi,%rbx
  800cdf:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ce2:	48 b8 70 0c 80 00 00 	movabs $0x800c70,%rax
  800ce9:	00 00 00 
  800cec:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800cee:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800cf2:	4c 89 e6             	mov    %r12,%rsi
  800cf5:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  800cfc:	00 00 00 
  800cff:	ff d0                	call   *%rax
    return dst;
}
  800d01:	48 89 d8             	mov    %rbx,%rax
  800d04:	5b                   	pop    %rbx
  800d05:	41 5c                	pop    %r12
  800d07:	5d                   	pop    %rbp
  800d08:	c3                   	ret

0000000000800d09 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d09:	f3 0f 1e fa          	endbr64
  800d0d:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800d10:	48 85 d2             	test   %rdx,%rdx
  800d13:	74 1f                	je     800d34 <strncpy+0x2b>
  800d15:	48 01 fa             	add    %rdi,%rdx
  800d18:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800d1b:	48 83 c1 01          	add    $0x1,%rcx
  800d1f:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d23:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d27:	41 80 f8 01          	cmp    $0x1,%r8b
  800d2b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d2f:	48 39 ca             	cmp    %rcx,%rdx
  800d32:	75 e7                	jne    800d1b <strncpy+0x12>
    }
    return ret;
}
  800d34:	c3                   	ret

0000000000800d35 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800d35:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800d39:	48 89 f8             	mov    %rdi,%rax
  800d3c:	48 85 d2             	test   %rdx,%rdx
  800d3f:	74 24                	je     800d65 <strlcpy+0x30>
        while (--size > 0 && *src)
  800d41:	48 83 ea 01          	sub    $0x1,%rdx
  800d45:	74 1b                	je     800d62 <strlcpy+0x2d>
  800d47:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d4b:	0f b6 16             	movzbl (%rsi),%edx
  800d4e:	84 d2                	test   %dl,%dl
  800d50:	74 10                	je     800d62 <strlcpy+0x2d>
            *dst++ = *src++;
  800d52:	48 83 c6 01          	add    $0x1,%rsi
  800d56:	48 83 c0 01          	add    $0x1,%rax
  800d5a:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d5d:	48 39 c8             	cmp    %rcx,%rax
  800d60:	75 e9                	jne    800d4b <strlcpy+0x16>
        *dst = '\0';
  800d62:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d65:	48 29 f8             	sub    %rdi,%rax
}
  800d68:	c3                   	ret

0000000000800d69 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800d69:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800d6d:	0f b6 07             	movzbl (%rdi),%eax
  800d70:	84 c0                	test   %al,%al
  800d72:	74 13                	je     800d87 <strcmp+0x1e>
  800d74:	38 06                	cmp    %al,(%rsi)
  800d76:	75 0f                	jne    800d87 <strcmp+0x1e>
  800d78:	48 83 c7 01          	add    $0x1,%rdi
  800d7c:	48 83 c6 01          	add    $0x1,%rsi
  800d80:	0f b6 07             	movzbl (%rdi),%eax
  800d83:	84 c0                	test   %al,%al
  800d85:	75 ed                	jne    800d74 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d87:	0f b6 c0             	movzbl %al,%eax
  800d8a:	0f b6 16             	movzbl (%rsi),%edx
  800d8d:	29 d0                	sub    %edx,%eax
}
  800d8f:	c3                   	ret

0000000000800d90 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800d90:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800d94:	48 85 d2             	test   %rdx,%rdx
  800d97:	74 1f                	je     800db8 <strncmp+0x28>
  800d99:	0f b6 07             	movzbl (%rdi),%eax
  800d9c:	84 c0                	test   %al,%al
  800d9e:	74 1e                	je     800dbe <strncmp+0x2e>
  800da0:	3a 06                	cmp    (%rsi),%al
  800da2:	75 1a                	jne    800dbe <strncmp+0x2e>
  800da4:	48 83 c7 01          	add    $0x1,%rdi
  800da8:	48 83 c6 01          	add    $0x1,%rsi
  800dac:	48 83 ea 01          	sub    $0x1,%rdx
  800db0:	75 e7                	jne    800d99 <strncmp+0x9>

    if (!n) return 0;
  800db2:	b8 00 00 00 00       	mov    $0x0,%eax
  800db7:	c3                   	ret
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbd:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800dbe:	0f b6 07             	movzbl (%rdi),%eax
  800dc1:	0f b6 16             	movzbl (%rsi),%edx
  800dc4:	29 d0                	sub    %edx,%eax
}
  800dc6:	c3                   	ret

0000000000800dc7 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800dc7:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800dcb:	0f b6 17             	movzbl (%rdi),%edx
  800dce:	84 d2                	test   %dl,%dl
  800dd0:	74 18                	je     800dea <strchr+0x23>
        if (*str == c) {
  800dd2:	0f be d2             	movsbl %dl,%edx
  800dd5:	39 f2                	cmp    %esi,%edx
  800dd7:	74 17                	je     800df0 <strchr+0x29>
    for (; *str; str++) {
  800dd9:	48 83 c7 01          	add    $0x1,%rdi
  800ddd:	0f b6 17             	movzbl (%rdi),%edx
  800de0:	84 d2                	test   %dl,%dl
  800de2:	75 ee                	jne    800dd2 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	c3                   	ret
  800dea:	b8 00 00 00 00       	mov    $0x0,%eax
  800def:	c3                   	ret
            return (char *)str;
  800df0:	48 89 f8             	mov    %rdi,%rax
}
  800df3:	c3                   	ret

0000000000800df4 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800df4:	f3 0f 1e fa          	endbr64
  800df8:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800dfb:	0f b6 17             	movzbl (%rdi),%edx
  800dfe:	84 d2                	test   %dl,%dl
  800e00:	74 13                	je     800e15 <strfind+0x21>
  800e02:	0f be d2             	movsbl %dl,%edx
  800e05:	39 f2                	cmp    %esi,%edx
  800e07:	74 0b                	je     800e14 <strfind+0x20>
  800e09:	48 83 c0 01          	add    $0x1,%rax
  800e0d:	0f b6 10             	movzbl (%rax),%edx
  800e10:	84 d2                	test   %dl,%dl
  800e12:	75 ee                	jne    800e02 <strfind+0xe>
        ;
    return (char *)str;
}
  800e14:	c3                   	ret
  800e15:	c3                   	ret

0000000000800e16 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e16:	f3 0f 1e fa          	endbr64
  800e1a:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e1d:	48 89 f8             	mov    %rdi,%rax
  800e20:	48 f7 d8             	neg    %rax
  800e23:	83 e0 07             	and    $0x7,%eax
  800e26:	49 89 d1             	mov    %rdx,%r9
  800e29:	49 29 c1             	sub    %rax,%r9
  800e2c:	78 36                	js     800e64 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e2e:	40 0f b6 c6          	movzbl %sil,%eax
  800e32:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800e39:	01 01 01 
  800e3c:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e40:	40 f6 c7 07          	test   $0x7,%dil
  800e44:	75 38                	jne    800e7e <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e46:	4c 89 c9             	mov    %r9,%rcx
  800e49:	48 c1 f9 03          	sar    $0x3,%rcx
  800e4d:	74 0c                	je     800e5b <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e4f:	fc                   	cld
  800e50:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e53:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800e57:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e5b:	4d 85 c9             	test   %r9,%r9
  800e5e:	75 45                	jne    800ea5 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e60:	4c 89 c0             	mov    %r8,%rax
  800e63:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800e64:	48 85 d2             	test   %rdx,%rdx
  800e67:	74 f7                	je     800e60 <memset+0x4a>
  800e69:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e6c:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e6f:	48 83 c0 01          	add    $0x1,%rax
  800e73:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e77:	48 39 c2             	cmp    %rax,%rdx
  800e7a:	75 f3                	jne    800e6f <memset+0x59>
  800e7c:	eb e2                	jmp    800e60 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e7e:	40 f6 c7 01          	test   $0x1,%dil
  800e82:	74 06                	je     800e8a <memset+0x74>
  800e84:	88 07                	mov    %al,(%rdi)
  800e86:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e8a:	40 f6 c7 02          	test   $0x2,%dil
  800e8e:	74 07                	je     800e97 <memset+0x81>
  800e90:	66 89 07             	mov    %ax,(%rdi)
  800e93:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e97:	40 f6 c7 04          	test   $0x4,%dil
  800e9b:	74 a9                	je     800e46 <memset+0x30>
  800e9d:	89 07                	mov    %eax,(%rdi)
  800e9f:	48 83 c7 04          	add    $0x4,%rdi
  800ea3:	eb a1                	jmp    800e46 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ea5:	41 f6 c1 04          	test   $0x4,%r9b
  800ea9:	74 1b                	je     800ec6 <memset+0xb0>
  800eab:	89 07                	mov    %eax,(%rdi)
  800ead:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800eb1:	41 f6 c1 02          	test   $0x2,%r9b
  800eb5:	74 07                	je     800ebe <memset+0xa8>
  800eb7:	66 89 07             	mov    %ax,(%rdi)
  800eba:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800ebe:	41 f6 c1 01          	test   $0x1,%r9b
  800ec2:	74 9c                	je     800e60 <memset+0x4a>
  800ec4:	eb 06                	jmp    800ecc <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ec6:	41 f6 c1 02          	test   $0x2,%r9b
  800eca:	75 eb                	jne    800eb7 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800ecc:	88 07                	mov    %al,(%rdi)
  800ece:	eb 90                	jmp    800e60 <memset+0x4a>

0000000000800ed0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ed0:	f3 0f 1e fa          	endbr64
  800ed4:	48 89 f8             	mov    %rdi,%rax
  800ed7:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800eda:	48 39 fe             	cmp    %rdi,%rsi
  800edd:	73 3b                	jae    800f1a <memmove+0x4a>
  800edf:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800ee3:	48 39 d7             	cmp    %rdx,%rdi
  800ee6:	73 32                	jae    800f1a <memmove+0x4a>
        s += n;
        d += n;
  800ee8:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800eec:	48 89 d6             	mov    %rdx,%rsi
  800eef:	48 09 fe             	or     %rdi,%rsi
  800ef2:	48 09 ce             	or     %rcx,%rsi
  800ef5:	40 f6 c6 07          	test   $0x7,%sil
  800ef9:	75 12                	jne    800f0d <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800efb:	48 83 ef 08          	sub    $0x8,%rdi
  800eff:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f03:	48 c1 e9 03          	shr    $0x3,%rcx
  800f07:	fd                   	std
  800f08:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f0b:	fc                   	cld
  800f0c:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f0d:	48 83 ef 01          	sub    $0x1,%rdi
  800f11:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f15:	fd                   	std
  800f16:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f18:	eb f1                	jmp    800f0b <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f1a:	48 89 f2             	mov    %rsi,%rdx
  800f1d:	48 09 c2             	or     %rax,%rdx
  800f20:	48 09 ca             	or     %rcx,%rdx
  800f23:	f6 c2 07             	test   $0x7,%dl
  800f26:	75 0c                	jne    800f34 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f28:	48 c1 e9 03          	shr    $0x3,%rcx
  800f2c:	48 89 c7             	mov    %rax,%rdi
  800f2f:	fc                   	cld
  800f30:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f33:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f34:	48 89 c7             	mov    %rax,%rdi
  800f37:	fc                   	cld
  800f38:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f3a:	c3                   	ret

0000000000800f3b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f3b:	f3 0f 1e fa          	endbr64
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f43:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  800f4a:	00 00 00 
  800f4d:	ff d0                	call   *%rax
}
  800f4f:	5d                   	pop    %rbp
  800f50:	c3                   	ret

0000000000800f51 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f51:	f3 0f 1e fa          	endbr64
  800f55:	55                   	push   %rbp
  800f56:	48 89 e5             	mov    %rsp,%rbp
  800f59:	41 57                	push   %r15
  800f5b:	41 56                	push   %r14
  800f5d:	41 55                	push   %r13
  800f5f:	41 54                	push   %r12
  800f61:	53                   	push   %rbx
  800f62:	48 83 ec 08          	sub    $0x8,%rsp
  800f66:	49 89 fe             	mov    %rdi,%r14
  800f69:	49 89 f7             	mov    %rsi,%r15
  800f6c:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f6f:	48 89 f7             	mov    %rsi,%rdi
  800f72:	48 b8 70 0c 80 00 00 	movabs $0x800c70,%rax
  800f79:	00 00 00 
  800f7c:	ff d0                	call   *%rax
  800f7e:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f81:	48 89 de             	mov    %rbx,%rsi
  800f84:	4c 89 f7             	mov    %r14,%rdi
  800f87:	48 b8 8f 0c 80 00 00 	movabs $0x800c8f,%rax
  800f8e:	00 00 00 
  800f91:	ff d0                	call   *%rax
  800f93:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f96:	48 39 c3             	cmp    %rax,%rbx
  800f99:	74 36                	je     800fd1 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800f9b:	48 89 d8             	mov    %rbx,%rax
  800f9e:	4c 29 e8             	sub    %r13,%rax
  800fa1:	49 39 c4             	cmp    %rax,%r12
  800fa4:	73 31                	jae    800fd7 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800fa6:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800fab:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800faf:	4c 89 fe             	mov    %r15,%rsi
  800fb2:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	call   *%rax
    return dstlen + srclen;
  800fbe:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800fc2:	48 83 c4 08          	add    $0x8,%rsp
  800fc6:	5b                   	pop    %rbx
  800fc7:	41 5c                	pop    %r12
  800fc9:	41 5d                	pop    %r13
  800fcb:	41 5e                	pop    %r14
  800fcd:	41 5f                	pop    %r15
  800fcf:	5d                   	pop    %rbp
  800fd0:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800fd1:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800fd5:	eb eb                	jmp    800fc2 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800fd7:	48 83 eb 01          	sub    $0x1,%rbx
  800fdb:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fdf:	48 89 da             	mov    %rbx,%rdx
  800fe2:	4c 89 fe             	mov    %r15,%rsi
  800fe5:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  800fec:	00 00 00 
  800fef:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800ff1:	49 01 de             	add    %rbx,%r14
  800ff4:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800ff9:	eb c3                	jmp    800fbe <strlcat+0x6d>

0000000000800ffb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800ffb:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800fff:	48 85 d2             	test   %rdx,%rdx
  801002:	74 2d                	je     801031 <memcmp+0x36>
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801009:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  80100d:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801012:	44 38 c1             	cmp    %r8b,%cl
  801015:	75 0f                	jne    801026 <memcmp+0x2b>
    while (n-- > 0) {
  801017:	48 83 c0 01          	add    $0x1,%rax
  80101b:	48 39 c2             	cmp    %rax,%rdx
  80101e:	75 e9                	jne    801009 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801020:	b8 00 00 00 00       	mov    $0x0,%eax
  801025:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801026:	0f b6 c1             	movzbl %cl,%eax
  801029:	45 0f b6 c0          	movzbl %r8b,%r8d
  80102d:	44 29 c0             	sub    %r8d,%eax
  801030:	c3                   	ret
    return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801036:	c3                   	ret

0000000000801037 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801037:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  80103b:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80103f:	48 39 c7             	cmp    %rax,%rdi
  801042:	73 0f                	jae    801053 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801044:	40 38 37             	cmp    %sil,(%rdi)
  801047:	74 0e                	je     801057 <memfind+0x20>
    for (; src < end; src++) {
  801049:	48 83 c7 01          	add    $0x1,%rdi
  80104d:	48 39 f8             	cmp    %rdi,%rax
  801050:	75 f2                	jne    801044 <memfind+0xd>
  801052:	c3                   	ret
  801053:	48 89 f8             	mov    %rdi,%rax
  801056:	c3                   	ret
  801057:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80105a:	c3                   	ret

000000000080105b <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80105b:	f3 0f 1e fa          	endbr64
  80105f:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801062:	0f b6 37             	movzbl (%rdi),%esi
  801065:	40 80 fe 20          	cmp    $0x20,%sil
  801069:	74 06                	je     801071 <strtol+0x16>
  80106b:	40 80 fe 09          	cmp    $0x9,%sil
  80106f:	75 13                	jne    801084 <strtol+0x29>
  801071:	48 83 c7 01          	add    $0x1,%rdi
  801075:	0f b6 37             	movzbl (%rdi),%esi
  801078:	40 80 fe 20          	cmp    $0x20,%sil
  80107c:	74 f3                	je     801071 <strtol+0x16>
  80107e:	40 80 fe 09          	cmp    $0x9,%sil
  801082:	74 ed                	je     801071 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801084:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801087:	83 e0 fd             	and    $0xfffffffd,%eax
  80108a:	3c 01                	cmp    $0x1,%al
  80108c:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801090:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801096:	75 0f                	jne    8010a7 <strtol+0x4c>
  801098:	80 3f 30             	cmpb   $0x30,(%rdi)
  80109b:	74 14                	je     8010b1 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80109d:	85 d2                	test   %edx,%edx
  80109f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a4:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8010a7:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8010ac:	4c 63 ca             	movslq %edx,%r9
  8010af:	eb 36                	jmp    8010e7 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010b1:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8010b5:	74 0f                	je     8010c6 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8010b7:	85 d2                	test   %edx,%edx
  8010b9:	75 ec                	jne    8010a7 <strtol+0x4c>
        s++;
  8010bb:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8010bf:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8010c4:	eb e1                	jmp    8010a7 <strtol+0x4c>
        s += 2;
  8010c6:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010ca:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8010cf:	eb d6                	jmp    8010a7 <strtol+0x4c>
            dig -= '0';
  8010d1:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8010d4:	44 0f b6 c1          	movzbl %cl,%r8d
  8010d8:	41 39 d0             	cmp    %edx,%r8d
  8010db:	7d 21                	jge    8010fe <strtol+0xa3>
        val = val * base + dig;
  8010dd:	49 0f af c1          	imul   %r9,%rax
  8010e1:	0f b6 c9             	movzbl %cl,%ecx
  8010e4:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8010e7:	48 83 c7 01          	add    $0x1,%rdi
  8010eb:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8010ef:	80 f9 39             	cmp    $0x39,%cl
  8010f2:	76 dd                	jbe    8010d1 <strtol+0x76>
        else if (dig - 'a' < 27)
  8010f4:	80 f9 7b             	cmp    $0x7b,%cl
  8010f7:	77 05                	ja     8010fe <strtol+0xa3>
            dig -= 'a' - 10;
  8010f9:	83 e9 57             	sub    $0x57,%ecx
  8010fc:	eb d6                	jmp    8010d4 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8010fe:	4d 85 d2             	test   %r10,%r10
  801101:	74 03                	je     801106 <strtol+0xab>
  801103:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801106:	48 89 c2             	mov    %rax,%rdx
  801109:	48 f7 da             	neg    %rdx
  80110c:	40 80 fe 2d          	cmp    $0x2d,%sil
  801110:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801114:	c3                   	ret

0000000000801115 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801115:	f3 0f 1e fa          	endbr64
  801119:	55                   	push   %rbp
  80111a:	48 89 e5             	mov    %rsp,%rbp
  80111d:	53                   	push   %rbx
  80111e:	48 89 fa             	mov    %rdi,%rdx
  801121:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801124:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801133:	be 00 00 00 00       	mov    $0x0,%esi
  801138:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80113e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801140:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801144:	c9                   	leave
  801145:	c3                   	ret

0000000000801146 <sys_cgetc>:

int
sys_cgetc(void) {
  801146:	f3 0f 1e fa          	endbr64
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
  80114e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80114f:	b8 01 00 00 00       	mov    $0x1,%eax
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
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801175:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801179:	c9                   	leave
  80117a:	c3                   	ret

000000000080117b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80117b:	f3 0f 1e fa          	endbr64
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	53                   	push   %rbx
  801184:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801188:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80118b:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801190:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801195:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80119f:	be 00 00 00 00       	mov    $0x0,%esi
  8011a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011ac:	48 85 c0             	test   %rax,%rax
  8011af:	7f 06                	jg     8011b7 <sys_env_destroy+0x3c>
}
  8011b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011b5:	c9                   	leave
  8011b6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011b7:	49 89 c0             	mov    %rax,%r8
  8011ba:	b9 03 00 00 00       	mov    $0x3,%ecx
  8011bf:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8011c6:	00 00 00 
  8011c9:	be 26 00 00 00       	mov    $0x26,%esi
  8011ce:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  8011d5:	00 00 00 
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dd:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  8011e4:	00 00 00 
  8011e7:	41 ff d1             	call   *%r9

00000000008011ea <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8011ea:	f3 0f 1e fa          	endbr64
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011f3:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801202:	bb 00 00 00 00       	mov    $0x0,%ebx
  801207:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80120c:	be 00 00 00 00       	mov    $0x0,%esi
  801211:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801217:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801219:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80121d:	c9                   	leave
  80121e:	c3                   	ret

000000000080121f <sys_yield>:

void
sys_yield(void) {
  80121f:	f3 0f 1e fa          	endbr64
  801223:	55                   	push   %rbp
  801224:	48 89 e5             	mov    %rsp,%rbp
  801227:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801228:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80122d:	ba 00 00 00 00       	mov    $0x0,%edx
  801232:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801237:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801241:	be 00 00 00 00       	mov    $0x0,%esi
  801246:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80124c:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80124e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801252:	c9                   	leave
  801253:	c3                   	ret

0000000000801254 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801254:	f3 0f 1e fa          	endbr64
  801258:	55                   	push   %rbp
  801259:	48 89 e5             	mov    %rsp,%rbp
  80125c:	53                   	push   %rbx
  80125d:	48 89 fa             	mov    %rdi,%rdx
  801260:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801263:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801268:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80126f:	00 00 00 
  801272:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801277:	be 00 00 00 00       	mov    $0x0,%esi
  80127c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801282:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801284:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801288:	c9                   	leave
  801289:	c3                   	ret

000000000080128a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80128a:	f3 0f 1e fa          	endbr64
  80128e:	55                   	push   %rbp
  80128f:	48 89 e5             	mov    %rsp,%rbp
  801292:	53                   	push   %rbx
  801293:	49 89 f8             	mov    %rdi,%r8
  801296:	48 89 d3             	mov    %rdx,%rbx
  801299:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80129c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a1:	4c 89 c2             	mov    %r8,%rdx
  8012a4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a7:	be 00 00 00 00       	mov    $0x0,%esi
  8012ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012b2:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8012b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b8:	c9                   	leave
  8012b9:	c3                   	ret

00000000008012ba <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8012ba:	f3 0f 1e fa          	endbr64
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	53                   	push   %rbx
  8012c3:	48 83 ec 08          	sub    $0x8,%rsp
  8012c7:	89 f8                	mov    %edi,%eax
  8012c9:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012cc:	48 63 f9             	movslq %ecx,%rdi
  8012cf:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d2:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d7:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012da:	be 00 00 00 00       	mov    $0x0,%esi
  8012df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012e5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012e7:	48 85 c0             	test   %rax,%rax
  8012ea:	7f 06                	jg     8012f2 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012f0:	c9                   	leave
  8012f1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012f2:	49 89 c0             	mov    %rax,%r8
  8012f5:	b9 04 00 00 00       	mov    $0x4,%ecx
  8012fa:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801301:	00 00 00 
  801304:	be 26 00 00 00       	mov    $0x26,%esi
  801309:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  801310:	00 00 00 
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
  801318:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  80131f:	00 00 00 
  801322:	41 ff d1             	call   *%r9

0000000000801325 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801325:	f3 0f 1e fa          	endbr64
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	53                   	push   %rbx
  80132e:	48 83 ec 08          	sub    $0x8,%rsp
  801332:	89 f8                	mov    %edi,%eax
  801334:	49 89 f2             	mov    %rsi,%r10
  801337:	48 89 cf             	mov    %rcx,%rdi
  80133a:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80133d:	48 63 da             	movslq %edx,%rbx
  801340:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801343:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801348:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80134b:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80134e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801350:	48 85 c0             	test   %rax,%rax
  801353:	7f 06                	jg     80135b <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801355:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801359:	c9                   	leave
  80135a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80135b:	49 89 c0             	mov    %rax,%r8
  80135e:	b9 05 00 00 00       	mov    $0x5,%ecx
  801363:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  80136a:	00 00 00 
  80136d:	be 26 00 00 00       	mov    $0x26,%esi
  801372:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  801379:	00 00 00 
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  801388:	00 00 00 
  80138b:	41 ff d1             	call   *%r9

000000000080138e <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80138e:	f3 0f 1e fa          	endbr64
  801392:	55                   	push   %rbp
  801393:	48 89 e5             	mov    %rsp,%rbp
  801396:	53                   	push   %rbx
  801397:	48 83 ec 08          	sub    $0x8,%rsp
  80139b:	49 89 f9             	mov    %rdi,%r9
  80139e:	89 f0                	mov    %esi,%eax
  8013a0:	48 89 d3             	mov    %rdx,%rbx
  8013a3:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8013a6:	49 63 f0             	movslq %r8d,%rsi
  8013a9:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013ac:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013b1:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013bc:	48 85 c0             	test   %rax,%rax
  8013bf:	7f 06                	jg     8013c7 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c5:	c9                   	leave
  8013c6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013c7:	49 89 c0             	mov    %rax,%r8
  8013ca:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013cf:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8013d6:	00 00 00 
  8013d9:	be 26 00 00 00       	mov    $0x26,%esi
  8013de:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  8013e5:	00 00 00 
  8013e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ed:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  8013f4:	00 00 00 
  8013f7:	41 ff d1             	call   *%r9

00000000008013fa <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8013fa:	f3 0f 1e fa          	endbr64
  8013fe:	55                   	push   %rbp
  8013ff:	48 89 e5             	mov    %rsp,%rbp
  801402:	53                   	push   %rbx
  801403:	48 83 ec 08          	sub    $0x8,%rsp
  801407:	48 89 f1             	mov    %rsi,%rcx
  80140a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80140d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801410:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801415:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80141a:	be 00 00 00 00       	mov    $0x0,%esi
  80141f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801425:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801427:	48 85 c0             	test   %rax,%rax
  80142a:	7f 06                	jg     801432 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80142c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801430:	c9                   	leave
  801431:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801432:	49 89 c0             	mov    %rax,%r8
  801435:	b9 07 00 00 00       	mov    $0x7,%ecx
  80143a:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801441:	00 00 00 
  801444:	be 26 00 00 00       	mov    $0x26,%esi
  801449:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  801450:	00 00 00 
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
  801458:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  80145f:	00 00 00 
  801462:	41 ff d1             	call   *%r9

0000000000801465 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801465:	f3 0f 1e fa          	endbr64
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	53                   	push   %rbx
  80146e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801472:	48 63 ce             	movslq %esi,%rcx
  801475:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801478:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80147d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801482:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801487:	be 00 00 00 00       	mov    $0x0,%esi
  80148c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801492:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801494:	48 85 c0             	test   %rax,%rax
  801497:	7f 06                	jg     80149f <sys_env_set_status+0x3a>
}
  801499:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80149d:	c9                   	leave
  80149e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80149f:	49 89 c0             	mov    %rax,%r8
  8014a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014a7:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8014ae:	00 00 00 
  8014b1:	be 26 00 00 00       	mov    $0x26,%esi
  8014b6:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  8014bd:	00 00 00 
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  8014cc:	00 00 00 
  8014cf:	41 ff d1             	call   *%r9

00000000008014d2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8014d2:	f3 0f 1e fa          	endbr64
  8014d6:	55                   	push   %rbp
  8014d7:	48 89 e5             	mov    %rsp,%rbp
  8014da:	53                   	push   %rbx
  8014db:	48 83 ec 08          	sub    $0x8,%rsp
  8014df:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8014e2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014e5:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ef:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f4:	be 00 00 00 00       	mov    $0x0,%esi
  8014f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ff:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801501:	48 85 c0             	test   %rax,%rax
  801504:	7f 06                	jg     80150c <sys_env_set_trapframe+0x3a>
}
  801506:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150a:	c9                   	leave
  80150b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80150c:	49 89 c0             	mov    %rax,%r8
  80150f:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801514:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  80151b:	00 00 00 
  80151e:	be 26 00 00 00       	mov    $0x26,%esi
  801523:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  80152a:	00 00 00 
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  801539:	00 00 00 
  80153c:	41 ff d1             	call   *%r9

000000000080153f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80153f:	f3 0f 1e fa          	endbr64
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	53                   	push   %rbx
  801548:	48 83 ec 08          	sub    $0x8,%rsp
  80154c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80154f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801552:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801557:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801561:	be 00 00 00 00       	mov    $0x0,%esi
  801566:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80156e:	48 85 c0             	test   %rax,%rax
  801571:	7f 06                	jg     801579 <sys_env_set_pgfault_upcall+0x3a>
}
  801573:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801577:	c9                   	leave
  801578:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801579:	49 89 c0             	mov    %rax,%r8
  80157c:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801581:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801588:	00 00 00 
  80158b:	be 26 00 00 00       	mov    $0x26,%esi
  801590:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  801597:	00 00 00 
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
  80159f:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  8015a6:	00 00 00 
  8015a9:	41 ff d1             	call   *%r9

00000000008015ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8015ac:	f3 0f 1e fa          	endbr64
  8015b0:	55                   	push   %rbp
  8015b1:	48 89 e5             	mov    %rsp,%rbp
  8015b4:	53                   	push   %rbx
  8015b5:	89 f8                	mov    %edi,%eax
  8015b7:	49 89 f1             	mov    %rsi,%r9
  8015ba:	48 89 d3             	mov    %rdx,%rbx
  8015bd:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8015c0:	49 63 f0             	movslq %r8d,%rsi
  8015c3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015c6:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015cb:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d4:	cd 30                	int    $0x30
}
  8015d6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015da:	c9                   	leave
  8015db:	c3                   	ret

00000000008015dc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8015dc:	f3 0f 1e fa          	endbr64
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	53                   	push   %rbx
  8015e5:	48 83 ec 08          	sub    $0x8,%rsp
  8015e9:	48 89 fa             	mov    %rdi,%rdx
  8015ec:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015ef:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015fe:	be 00 00 00 00       	mov    $0x0,%esi
  801603:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801609:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80160b:	48 85 c0             	test   %rax,%rax
  80160e:	7f 06                	jg     801616 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801610:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801614:	c9                   	leave
  801615:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801616:	49 89 c0             	mov    %rax,%r8
  801619:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80161e:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801625:	00 00 00 
  801628:	be 26 00 00 00       	mov    $0x26,%esi
  80162d:	48 bf ba 41 80 00 00 	movabs $0x8041ba,%rdi
  801634:	00 00 00 
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	49 b9 10 02 80 00 00 	movabs $0x800210,%r9
  801643:	00 00 00 
  801646:	41 ff d1             	call   *%r9

0000000000801649 <sys_gettime>:

int
sys_gettime(void) {
  801649:	f3 0f 1e fa          	endbr64
  80164d:	55                   	push   %rbp
  80164e:	48 89 e5             	mov    %rsp,%rbp
  801651:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801652:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801657:	ba 00 00 00 00       	mov    $0x0,%edx
  80165c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801661:	bb 00 00 00 00       	mov    $0x0,%ebx
  801666:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80166b:	be 00 00 00 00       	mov    $0x0,%esi
  801670:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801676:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801678:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80167c:	c9                   	leave
  80167d:	c3                   	ret

000000000080167e <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80167e:	f3 0f 1e fa          	endbr64
  801682:	55                   	push   %rbp
  801683:	48 89 e5             	mov    %rsp,%rbp
  801686:	41 56                	push   %r14
  801688:	41 55                	push   %r13
  80168a:	41 54                	push   %r12
  80168c:	53                   	push   %rbx
  80168d:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  801690:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  801697:	00 00 00 
  80169a:	48 83 38 00          	cmpq   $0x0,(%rax)
  80169e:	74 27                	je     8016c7 <_handle_vectored_pagefault+0x49>
  8016a0:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8016a5:	49 bd 20 60 80 00 00 	movabs $0x806020,%r13
  8016ac:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8016af:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8016b2:	4c 89 e7             	mov    %r12,%rdi
  8016b5:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8016ba:	84 c0                	test   %al,%al
  8016bc:	75 45                	jne    801703 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8016be:	48 83 c3 01          	add    $0x1,%rbx
  8016c2:	49 3b 1e             	cmp    (%r14),%rbx
  8016c5:	72 eb                	jb     8016b2 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8016c7:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8016ce:	00 
  8016cf:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8016d4:	4d 8b 04 24          	mov    (%r12),%r8
  8016d8:	48 ba 78 43 80 00 00 	movabs $0x804378,%rdx
  8016df:	00 00 00 
  8016e2:	be 1d 00 00 00       	mov    $0x1d,%esi
  8016e7:	48 bf c8 41 80 00 00 	movabs $0x8041c8,%rdi
  8016ee:	00 00 00 
  8016f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f6:	49 ba 10 02 80 00 00 	movabs $0x800210,%r10
  8016fd:	00 00 00 
  801700:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  801703:	5b                   	pop    %rbx
  801704:	41 5c                	pop    %r12
  801706:	41 5d                	pop    %r13
  801708:	41 5e                	pop    %r14
  80170a:	5d                   	pop    %rbp
  80170b:	c3                   	ret

000000000080170c <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  80170c:	f3 0f 1e fa          	endbr64
  801710:	55                   	push   %rbp
  801711:	48 89 e5             	mov    %rsp,%rbp
  801714:	53                   	push   %rbx
  801715:	48 83 ec 08          	sub    $0x8,%rsp
  801719:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  80171c:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  801723:	00 00 00 
  801726:	80 38 00             	cmpb   $0x0,(%rax)
  801729:	0f 84 84 00 00 00    	je     8017b3 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80172f:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  801736:	00 00 00 
  801739:	48 8b 10             	mov    (%rax),%rdx
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  801741:	48 b9 20 60 80 00 00 	movabs $0x806020,%rcx
  801748:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80174b:	48 85 d2             	test   %rdx,%rdx
  80174e:	74 19                	je     801769 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  801750:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  801754:	0f 84 e8 00 00 00    	je     801842 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80175a:	48 83 c0 01          	add    $0x1,%rax
  80175e:	48 39 d0             	cmp    %rdx,%rax
  801761:	75 ed                	jne    801750 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  801763:	48 83 fa 08          	cmp    $0x8,%rdx
  801767:	74 1c                	je     801785 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  801769:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80176d:	48 a3 68 60 80 00 00 	movabs %rax,0x806068
  801774:	00 00 00 
  801777:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80177e:	00 00 00 
  801781:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801785:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  80178c:	00 00 00 
  80178f:	ff d0                	call   *%rax
  801791:	89 c7                	mov    %eax,%edi
  801793:	48 be 0c 19 80 00 00 	movabs $0x80190c,%rsi
  80179a:	00 00 00 
  80179d:	48 b8 3f 15 80 00 00 	movabs $0x80153f,%rax
  8017a4:	00 00 00 
  8017a7:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 68                	js     801815 <add_pgfault_handler+0x109>
    return res;
}
  8017ad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017b1:	c9                   	leave
  8017b2:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8017b3:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	call   *%rax
  8017bf:	89 c7                	mov    %eax,%edi
  8017c1:	b9 06 00 00 00       	mov    $0x6,%ecx
  8017c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8017cb:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8017d2:	00 00 00 
  8017d5:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  8017dc:	00 00 00 
  8017df:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  8017e1:	48 ba 68 60 80 00 00 	movabs $0x806068,%rdx
  8017e8:	00 00 00 
  8017eb:	48 8b 02             	mov    (%rdx),%rax
  8017ee:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8017f2:	48 89 0a             	mov    %rcx,(%rdx)
  8017f5:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  8017fc:	00 00 00 
  8017ff:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  801803:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80180a:	00 00 00 
  80180d:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  801810:	e9 70 ff ff ff       	jmp    801785 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801815:	89 c1                	mov    %eax,%ecx
  801817:	48 ba d6 41 80 00 00 	movabs $0x8041d6,%rdx
  80181e:	00 00 00 
  801821:	be 3d 00 00 00       	mov    $0x3d,%esi
  801826:	48 bf c8 41 80 00 00 	movabs $0x8041c8,%rdi
  80182d:	00 00 00 
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	49 b8 10 02 80 00 00 	movabs $0x800210,%r8
  80183c:	00 00 00 
  80183f:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	e9 61 ff ff ff       	jmp    8017ad <add_pgfault_handler+0xa1>

000000000080184c <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  80184c:	f3 0f 1e fa          	endbr64
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  801854:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80185b:	00 00 00 
  80185e:	80 38 00             	cmpb   $0x0,(%rax)
  801861:	74 33                	je     801896 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  801863:	48 a1 68 60 80 00 00 	movabs 0x806068,%rax
  80186a:	00 00 00 
  80186d:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  801872:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  801879:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80187c:	48 85 c0             	test   %rax,%rax
  80187f:	0f 84 85 00 00 00    	je     80190a <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  801885:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  801889:	74 40                	je     8018cb <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80188b:	48 83 c1 01          	add    $0x1,%rcx
  80188f:	48 39 c1             	cmp    %rax,%rcx
  801892:	75 f1                	jne    801885 <remove_pgfault_handler+0x39>
  801894:	eb 74                	jmp    80190a <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  801896:	48 b9 ee 41 80 00 00 	movabs $0x8041ee,%rcx
  80189d:	00 00 00 
  8018a0:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
  8018a7:	00 00 00 
  8018aa:	be 43 00 00 00       	mov    $0x43,%esi
  8018af:	48 bf c8 41 80 00 00 	movabs $0x8041c8,%rdi
  8018b6:	00 00 00 
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	49 b8 10 02 80 00 00 	movabs $0x800210,%r8
  8018c5:	00 00 00 
  8018c8:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8018cb:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8018d2:	00 
  8018d3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018d7:	48 29 ca             	sub    %rcx,%rdx
  8018da:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8018e1:	00 00 00 
  8018e4:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  8018e8:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  8018ed:	48 89 ce             	mov    %rcx,%rsi
  8018f0:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  8018f7:	00 00 00 
  8018fa:	ff d0                	call   *%rax
            _pfhandler_off--;
  8018fc:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  801903:	00 00 00 
  801906:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80190a:	5d                   	pop    %rbp
  80190b:	c3                   	ret

000000000080190c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  80190c:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  80190f:	48 b8 7e 16 80 00 00 	movabs $0x80167e,%rax
  801916:	00 00 00 
    call *%rax
  801919:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  80191b:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  80191e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801925:	00 
    movq UTRAP_RSP(%rsp), %rsp
  801926:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80192d:	00 
    pushq %rbx
  80192e:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  80192f:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  801936:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  801939:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  80193d:	4c 8b 3c 24          	mov    (%rsp),%r15
  801941:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801946:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80194b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801950:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801955:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80195a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80195f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801964:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801969:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80196e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801973:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801978:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80197d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801982:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801987:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  80198b:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80198f:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  801990:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  801991:	c3                   	ret

0000000000801992 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801992:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801996:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80199d:	ff ff ff 
  8019a0:	48 01 f8             	add    %rdi,%rax
  8019a3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019a7:	c3                   	ret

00000000008019a8 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8019a8:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019b3:	ff ff ff 
  8019b6:	48 01 f8             	add    %rdi,%rax
  8019b9:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8019bd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019c3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8019c7:	c3                   	ret

00000000008019c8 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8019c8:	f3 0f 1e fa          	endbr64
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	41 57                	push   %r15
  8019d2:	41 56                	push   %r14
  8019d4:	41 55                	push   %r13
  8019d6:	41 54                	push   %r12
  8019d8:	53                   	push   %rbx
  8019d9:	48 83 ec 08          	sub    $0x8,%rsp
  8019dd:	49 89 ff             	mov    %rdi,%r15
  8019e0:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019e5:	49 bd 27 2b 80 00 00 	movabs $0x802b27,%r13
  8019ec:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019ef:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8019f5:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8019f8:	48 89 df             	mov    %rbx,%rdi
  8019fb:	41 ff d5             	call   *%r13
  8019fe:	83 e0 04             	and    $0x4,%eax
  801a01:	74 17                	je     801a1a <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801a03:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a0a:	4c 39 f3             	cmp    %r14,%rbx
  801a0d:	75 e6                	jne    8019f5 <fd_alloc+0x2d>
  801a0f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801a15:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801a1a:	4d 89 27             	mov    %r12,(%r15)
}
  801a1d:	48 83 c4 08          	add    $0x8,%rsp
  801a21:	5b                   	pop    %rbx
  801a22:	41 5c                	pop    %r12
  801a24:	41 5d                	pop    %r13
  801a26:	41 5e                	pop    %r14
  801a28:	41 5f                	pop    %r15
  801a2a:	5d                   	pop    %rbp
  801a2b:	c3                   	ret

0000000000801a2c <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a2c:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a30:	83 ff 1f             	cmp    $0x1f,%edi
  801a33:	77 39                	ja     801a6e <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a35:	55                   	push   %rbp
  801a36:	48 89 e5             	mov    %rsp,%rbp
  801a39:	41 54                	push   %r12
  801a3b:	53                   	push   %rbx
  801a3c:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a3f:	48 63 df             	movslq %edi,%rbx
  801a42:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a49:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a4d:	48 89 df             	mov    %rbx,%rdi
  801a50:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	call   *%rax
  801a5c:	a8 04                	test   $0x4,%al
  801a5e:	74 14                	je     801a74 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a60:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a69:	5b                   	pop    %rbx
  801a6a:	41 5c                	pop    %r12
  801a6c:	5d                   	pop    %rbp
  801a6d:	c3                   	ret
        return -E_INVAL;
  801a6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a73:	c3                   	ret
        return -E_INVAL;
  801a74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a79:	eb ee                	jmp    801a69 <fd_lookup+0x3d>

0000000000801a7b <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a7b:	f3 0f 1e fa          	endbr64
  801a7f:	55                   	push   %rbp
  801a80:	48 89 e5             	mov    %rsp,%rbp
  801a83:	41 54                	push   %r12
  801a85:	53                   	push   %rbx
  801a86:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a89:	48 b8 80 47 80 00 00 	movabs $0x804780,%rax
  801a90:	00 00 00 
  801a93:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801a9a:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a9d:	39 3b                	cmp    %edi,(%rbx)
  801a9f:	74 47                	je     801ae8 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801aa1:	48 83 c0 08          	add    $0x8,%rax
  801aa5:	48 8b 18             	mov    (%rax),%rbx
  801aa8:	48 85 db             	test   %rbx,%rbx
  801aab:	75 f0                	jne    801a9d <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801aad:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801ab4:	00 00 00 
  801ab7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801abd:	89 fa                	mov    %edi,%edx
  801abf:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  801ac6:	00 00 00 
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ace:	48 b9 6c 03 80 00 00 	movabs $0x80036c,%rcx
  801ad5:	00 00 00 
  801ad8:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801ada:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801adf:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801ae3:	5b                   	pop    %rbx
  801ae4:	41 5c                	pop    %r12
  801ae6:	5d                   	pop    %rbp
  801ae7:	c3                   	ret
            return 0;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	eb f0                	jmp    801adf <dev_lookup+0x64>

0000000000801aef <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801aef:	f3 0f 1e fa          	endbr64
  801af3:	55                   	push   %rbp
  801af4:	48 89 e5             	mov    %rsp,%rbp
  801af7:	41 55                	push   %r13
  801af9:	41 54                	push   %r12
  801afb:	53                   	push   %rbx
  801afc:	48 83 ec 18          	sub    $0x18,%rsp
  801b00:	48 89 fb             	mov    %rdi,%rbx
  801b03:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b06:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b0d:	ff ff ff 
  801b10:	48 01 df             	add    %rbx,%rdi
  801b13:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b17:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b1b:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801b22:	00 00 00 
  801b25:	ff d0                	call   *%rax
  801b27:	41 89 c5             	mov    %eax,%r13d
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	78 06                	js     801b34 <fd_close+0x45>
  801b2e:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801b32:	74 1a                	je     801b4e <fd_close+0x5f>
        return (must_exist ? res : 0);
  801b34:	45 84 e4             	test   %r12b,%r12b
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3c:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801b40:	44 89 e8             	mov    %r13d,%eax
  801b43:	48 83 c4 18          	add    $0x18,%rsp
  801b47:	5b                   	pop    %rbx
  801b48:	41 5c                	pop    %r12
  801b4a:	41 5d                	pop    %r13
  801b4c:	5d                   	pop    %rbp
  801b4d:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b4e:	8b 3b                	mov    (%rbx),%edi
  801b50:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b54:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	call   *%rax
  801b60:	41 89 c5             	mov    %eax,%r13d
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 1b                	js     801b82 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b6b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b6f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b75:	48 85 c0             	test   %rax,%rax
  801b78:	74 08                	je     801b82 <fd_close+0x93>
  801b7a:	48 89 df             	mov    %rbx,%rdi
  801b7d:	ff d0                	call   *%rax
  801b7f:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b82:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b87:	48 89 de             	mov    %rbx,%rsi
  801b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8f:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  801b96:	00 00 00 
  801b99:	ff d0                	call   *%rax
    return res;
  801b9b:	eb a3                	jmp    801b40 <fd_close+0x51>

0000000000801b9d <close>:

int
close(int fdnum) {
  801b9d:	f3 0f 1e fa          	endbr64
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801ba9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801bad:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	call   *%rax
    if (res < 0) return res;
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 15                	js     801bd2 <close+0x35>

    return fd_close(fd, 1);
  801bbd:	be 01 00 00 00       	mov    $0x1,%esi
  801bc2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bc6:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	call   *%rax
}
  801bd2:	c9                   	leave
  801bd3:	c3                   	ret

0000000000801bd4 <close_all>:

void
close_all(void) {
  801bd4:	f3 0f 1e fa          	endbr64
  801bd8:	55                   	push   %rbp
  801bd9:	48 89 e5             	mov    %rsp,%rbp
  801bdc:	41 54                	push   %r12
  801bde:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801bdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be4:	49 bc 9d 1b 80 00 00 	movabs $0x801b9d,%r12
  801beb:	00 00 00 
  801bee:	89 df                	mov    %ebx,%edi
  801bf0:	41 ff d4             	call   *%r12
  801bf3:	83 c3 01             	add    $0x1,%ebx
  801bf6:	83 fb 20             	cmp    $0x20,%ebx
  801bf9:	75 f3                	jne    801bee <close_all+0x1a>
}
  801bfb:	5b                   	pop    %rbx
  801bfc:	41 5c                	pop    %r12
  801bfe:	5d                   	pop    %rbp
  801bff:	c3                   	ret

0000000000801c00 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c00:	f3 0f 1e fa          	endbr64
  801c04:	55                   	push   %rbp
  801c05:	48 89 e5             	mov    %rsp,%rbp
  801c08:	41 57                	push   %r15
  801c0a:	41 56                	push   %r14
  801c0c:	41 55                	push   %r13
  801c0e:	41 54                	push   %r12
  801c10:	53                   	push   %rbx
  801c11:	48 83 ec 18          	sub    $0x18,%rsp
  801c15:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c18:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801c1c:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801c23:	00 00 00 
  801c26:	ff d0                	call   *%rax
  801c28:	89 c3                	mov    %eax,%ebx
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	0f 88 b8 00 00 00    	js     801cea <dup+0xea>
    close(newfdnum);
  801c32:	44 89 e7             	mov    %r12d,%edi
  801c35:	48 b8 9d 1b 80 00 00 	movabs $0x801b9d,%rax
  801c3c:	00 00 00 
  801c3f:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c41:	4d 63 ec             	movslq %r12d,%r13
  801c44:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c4b:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c4f:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801c53:	4c 89 ff             	mov    %r15,%rdi
  801c56:	49 be a8 19 80 00 00 	movabs $0x8019a8,%r14
  801c5d:	00 00 00 
  801c60:	41 ff d6             	call   *%r14
  801c63:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c66:	4c 89 ef             	mov    %r13,%rdi
  801c69:	41 ff d6             	call   *%r14
  801c6c:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c6f:	48 89 df             	mov    %rbx,%rdi
  801c72:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c7e:	a8 04                	test   $0x4,%al
  801c80:	74 2b                	je     801cad <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c82:	41 89 c1             	mov    %eax,%r9d
  801c85:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c8b:	4c 89 f1             	mov    %r14,%rcx
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c93:	48 89 de             	mov    %rbx,%rsi
  801c96:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9b:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	call   *%rax
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	78 4e                	js     801cfb <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801cad:	4c 89 ff             	mov    %r15,%rdi
  801cb0:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  801cb7:	00 00 00 
  801cba:	ff d0                	call   *%rax
  801cbc:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801cbf:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801cc5:	4c 89 e9             	mov    %r13,%rcx
  801cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccd:	4c 89 fe             	mov    %r15,%rsi
  801cd0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd5:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	call   *%rax
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	78 14                	js     801cfb <dup+0xfb>

    return newfdnum;
  801ce7:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801cea:	89 d8                	mov    %ebx,%eax
  801cec:	48 83 c4 18          	add    $0x18,%rsp
  801cf0:	5b                   	pop    %rbx
  801cf1:	41 5c                	pop    %r12
  801cf3:	41 5d                	pop    %r13
  801cf5:	41 5e                	pop    %r14
  801cf7:	41 5f                	pop    %r15
  801cf9:	5d                   	pop    %rbp
  801cfa:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801cfb:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d00:	4c 89 ee             	mov    %r13,%rsi
  801d03:	bf 00 00 00 00       	mov    $0x0,%edi
  801d08:	49 bc fa 13 80 00 00 	movabs $0x8013fa,%r12
  801d0f:	00 00 00 
  801d12:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d15:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d1a:	4c 89 f6             	mov    %r14,%rsi
  801d1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d22:	41 ff d4             	call   *%r12
    return res;
  801d25:	eb c3                	jmp    801cea <dup+0xea>

0000000000801d27 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d27:	f3 0f 1e fa          	endbr64
  801d2b:	55                   	push   %rbp
  801d2c:	48 89 e5             	mov    %rsp,%rbp
  801d2f:	41 56                	push   %r14
  801d31:	41 55                	push   %r13
  801d33:	41 54                	push   %r12
  801d35:	53                   	push   %rbx
  801d36:	48 83 ec 10          	sub    $0x10,%rsp
  801d3a:	89 fb                	mov    %edi,%ebx
  801d3c:	49 89 f4             	mov    %rsi,%r12
  801d3f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d42:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d46:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801d4d:	00 00 00 
  801d50:	ff d0                	call   *%rax
  801d52:	85 c0                	test   %eax,%eax
  801d54:	78 4c                	js     801da2 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d56:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d5a:	41 8b 3e             	mov    (%r14),%edi
  801d5d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d61:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	call   *%rax
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 35                	js     801da6 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d71:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d75:	83 e0 03             	and    $0x3,%eax
  801d78:	83 f8 01             	cmp    $0x1,%eax
  801d7b:	74 2d                	je     801daa <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d81:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d85:	48 85 c0             	test   %rax,%rax
  801d88:	74 56                	je     801de0 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d8a:	4c 89 ea             	mov    %r13,%rdx
  801d8d:	4c 89 e6             	mov    %r12,%rsi
  801d90:	4c 89 f7             	mov    %r14,%rdi
  801d93:	ff d0                	call   *%rax
}
  801d95:	48 83 c4 10          	add    $0x10,%rsp
  801d99:	5b                   	pop    %rbx
  801d9a:	41 5c                	pop    %r12
  801d9c:	41 5d                	pop    %r13
  801d9e:	41 5e                	pop    %r14
  801da0:	5d                   	pop    %rbp
  801da1:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801da2:	48 98                	cltq
  801da4:	eb ef                	jmp    801d95 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801da6:	48 98                	cltq
  801da8:	eb eb                	jmp    801d95 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801daa:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801db1:	00 00 00 
  801db4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dba:	89 da                	mov    %ebx,%edx
  801dbc:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  801dc3:	00 00 00 
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcb:	48 b9 6c 03 80 00 00 	movabs $0x80036c,%rcx
  801dd2:	00 00 00 
  801dd5:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dd7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dde:	eb b5                	jmp    801d95 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801de0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801de7:	eb ac                	jmp    801d95 <read+0x6e>

0000000000801de9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801de9:	f3 0f 1e fa          	endbr64
  801ded:	55                   	push   %rbp
  801dee:	48 89 e5             	mov    %rsp,%rbp
  801df1:	41 57                	push   %r15
  801df3:	41 56                	push   %r14
  801df5:	41 55                	push   %r13
  801df7:	41 54                	push   %r12
  801df9:	53                   	push   %rbx
  801dfa:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801dfe:	48 85 d2             	test   %rdx,%rdx
  801e01:	74 54                	je     801e57 <readn+0x6e>
  801e03:	41 89 fd             	mov    %edi,%r13d
  801e06:	49 89 f6             	mov    %rsi,%r14
  801e09:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e0c:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e16:	49 bf 27 1d 80 00 00 	movabs $0x801d27,%r15
  801e1d:	00 00 00 
  801e20:	4c 89 e2             	mov    %r12,%rdx
  801e23:	48 29 f2             	sub    %rsi,%rdx
  801e26:	4c 01 f6             	add    %r14,%rsi
  801e29:	44 89 ef             	mov    %r13d,%edi
  801e2c:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 20                	js     801e53 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801e33:	01 c3                	add    %eax,%ebx
  801e35:	85 c0                	test   %eax,%eax
  801e37:	74 08                	je     801e41 <readn+0x58>
  801e39:	48 63 f3             	movslq %ebx,%rsi
  801e3c:	4c 39 e6             	cmp    %r12,%rsi
  801e3f:	72 df                	jb     801e20 <readn+0x37>
    }
    return res;
  801e41:	48 63 c3             	movslq %ebx,%rax
}
  801e44:	48 83 c4 08          	add    $0x8,%rsp
  801e48:	5b                   	pop    %rbx
  801e49:	41 5c                	pop    %r12
  801e4b:	41 5d                	pop    %r13
  801e4d:	41 5e                	pop    %r14
  801e4f:	41 5f                	pop    %r15
  801e51:	5d                   	pop    %rbp
  801e52:	c3                   	ret
        if (inc < 0) return inc;
  801e53:	48 98                	cltq
  801e55:	eb ed                	jmp    801e44 <readn+0x5b>
    int inc = 1, res = 0;
  801e57:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e5c:	eb e3                	jmp    801e41 <readn+0x58>

0000000000801e5e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e5e:	f3 0f 1e fa          	endbr64
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	41 56                	push   %r14
  801e68:	41 55                	push   %r13
  801e6a:	41 54                	push   %r12
  801e6c:	53                   	push   %rbx
  801e6d:	48 83 ec 10          	sub    $0x10,%rsp
  801e71:	89 fb                	mov    %edi,%ebx
  801e73:	49 89 f4             	mov    %rsi,%r12
  801e76:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e79:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e7d:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	call   *%rax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	78 47                	js     801ed4 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e8d:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e91:	41 8b 3e             	mov    (%r14),%edi
  801e94:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e98:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	call   *%rax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	78 30                	js     801ed8 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ea8:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801ead:	74 2d                	je     801edc <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801eaf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eb3:	48 8b 40 18          	mov    0x18(%rax),%rax
  801eb7:	48 85 c0             	test   %rax,%rax
  801eba:	74 56                	je     801f12 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801ebc:	4c 89 ea             	mov    %r13,%rdx
  801ebf:	4c 89 e6             	mov    %r12,%rsi
  801ec2:	4c 89 f7             	mov    %r14,%rdi
  801ec5:	ff d0                	call   *%rax
}
  801ec7:	48 83 c4 10          	add    $0x10,%rsp
  801ecb:	5b                   	pop    %rbx
  801ecc:	41 5c                	pop    %r12
  801ece:	41 5d                	pop    %r13
  801ed0:	41 5e                	pop    %r14
  801ed2:	5d                   	pop    %rbp
  801ed3:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ed4:	48 98                	cltq
  801ed6:	eb ef                	jmp    801ec7 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ed8:	48 98                	cltq
  801eda:	eb eb                	jmp    801ec7 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801edc:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801ee3:	00 00 00 
  801ee6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801eec:	89 da                	mov    %ebx,%edx
  801eee:	48 bf 39 42 80 00 00 	movabs $0x804239,%rdi
  801ef5:	00 00 00 
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	48 b9 6c 03 80 00 00 	movabs $0x80036c,%rcx
  801f04:	00 00 00 
  801f07:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f09:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f10:	eb b5                	jmp    801ec7 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f12:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f19:	eb ac                	jmp    801ec7 <write+0x69>

0000000000801f1b <seek>:

int
seek(int fdnum, off_t offset) {
  801f1b:	f3 0f 1e fa          	endbr64
  801f1f:	55                   	push   %rbp
  801f20:	48 89 e5             	mov    %rsp,%rbp
  801f23:	53                   	push   %rbx
  801f24:	48 83 ec 18          	sub    $0x18,%rsp
  801f28:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f2a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f2e:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801f35:	00 00 00 
  801f38:	ff d0                	call   *%rax
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	78 0c                	js     801f4a <seek+0x2f>

    fd->fd_offset = offset;
  801f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f42:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f4e:	c9                   	leave
  801f4f:	c3                   	ret

0000000000801f50 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f50:	f3 0f 1e fa          	endbr64
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	41 55                	push   %r13
  801f5a:	41 54                	push   %r12
  801f5c:	53                   	push   %rbx
  801f5d:	48 83 ec 18          	sub    $0x18,%rsp
  801f61:	89 fb                	mov    %edi,%ebx
  801f63:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f66:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f6a:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801f71:	00 00 00 
  801f74:	ff d0                	call   *%rax
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 38                	js     801fb2 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f7a:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f7e:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f82:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f86:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  801f8d:	00 00 00 
  801f90:	ff d0                	call   *%rax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 1c                	js     801fb2 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f96:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f9b:	74 20                	je     801fbd <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa1:	48 8b 40 30          	mov    0x30(%rax),%rax
  801fa5:	48 85 c0             	test   %rax,%rax
  801fa8:	74 47                	je     801ff1 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801faa:	44 89 e6             	mov    %r12d,%esi
  801fad:	4c 89 ef             	mov    %r13,%rdi
  801fb0:	ff d0                	call   *%rax
}
  801fb2:	48 83 c4 18          	add    $0x18,%rsp
  801fb6:	5b                   	pop    %rbx
  801fb7:	41 5c                	pop    %r12
  801fb9:	41 5d                	pop    %r13
  801fbb:	5d                   	pop    %rbp
  801fbc:	c3                   	ret
                thisenv->env_id, fdnum);
  801fbd:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801fc4:	00 00 00 
  801fc7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801fcd:	89 da                	mov    %ebx,%edx
  801fcf:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  801fd6:	00 00 00 
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	48 b9 6c 03 80 00 00 	movabs $0x80036c,%rcx
  801fe5:	00 00 00 
  801fe8:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fef:	eb c1                	jmp    801fb2 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ff1:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ff6:	eb ba                	jmp    801fb2 <ftruncate+0x62>

0000000000801ff8 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ff8:	f3 0f 1e fa          	endbr64
  801ffc:	55                   	push   %rbp
  801ffd:	48 89 e5             	mov    %rsp,%rbp
  802000:	41 54                	push   %r12
  802002:	53                   	push   %rbx
  802003:	48 83 ec 10          	sub    $0x10,%rsp
  802007:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80200a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80200e:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  802015:	00 00 00 
  802018:	ff d0                	call   *%rax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 4e                	js     80206c <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80201e:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802022:	41 8b 3c 24          	mov    (%r12),%edi
  802026:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80202a:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  802031:	00 00 00 
  802034:	ff d0                	call   *%rax
  802036:	85 c0                	test   %eax,%eax
  802038:	78 32                	js     80206c <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80203a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80203e:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802043:	74 30                	je     802075 <fstat+0x7d>

    stat->st_name[0] = 0;
  802045:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802048:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  80204f:	00 00 00 
    stat->st_isdir = 0;
  802052:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802059:	00 00 00 
    stat->st_dev = dev;
  80205c:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802063:	48 89 de             	mov    %rbx,%rsi
  802066:	4c 89 e7             	mov    %r12,%rdi
  802069:	ff 50 28             	call   *0x28(%rax)
}
  80206c:	48 83 c4 10          	add    $0x10,%rsp
  802070:	5b                   	pop    %rbx
  802071:	41 5c                	pop    %r12
  802073:	5d                   	pop    %rbp
  802074:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802075:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80207a:	eb f0                	jmp    80206c <fstat+0x74>

000000000080207c <stat>:

int
stat(const char *path, struct Stat *stat) {
  80207c:	f3 0f 1e fa          	endbr64
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	41 54                	push   %r12
  802086:	53                   	push   %rbx
  802087:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  80208f:	48 b8 5d 23 80 00 00 	movabs $0x80235d,%rax
  802096:	00 00 00 
  802099:	ff d0                	call   *%rax
  80209b:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 25                	js     8020c6 <stat+0x4a>

    int res = fstat(fd, stat);
  8020a1:	4c 89 e6             	mov    %r12,%rsi
  8020a4:	89 c7                	mov    %eax,%edi
  8020a6:	48 b8 f8 1f 80 00 00 	movabs $0x801ff8,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
  8020b2:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8020b5:	89 df                	mov    %ebx,%edi
  8020b7:	48 b8 9d 1b 80 00 00 	movabs $0x801b9d,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	call   *%rax

    return res;
  8020c3:	44 89 e3             	mov    %r12d,%ebx
}
  8020c6:	89 d8                	mov    %ebx,%eax
  8020c8:	5b                   	pop    %rbx
  8020c9:	41 5c                	pop    %r12
  8020cb:	5d                   	pop    %rbp
  8020cc:	c3                   	ret

00000000008020cd <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8020cd:	f3 0f 1e fa          	endbr64
  8020d1:	55                   	push   %rbp
  8020d2:	48 89 e5             	mov    %rsp,%rbp
  8020d5:	41 54                	push   %r12
  8020d7:	53                   	push   %rbx
  8020d8:	48 83 ec 10          	sub    $0x10,%rsp
  8020dc:	41 89 fc             	mov    %edi,%r12d
  8020df:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020e2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8020e9:	00 00 00 
  8020ec:	83 38 00             	cmpl   $0x0,(%rax)
  8020ef:	74 6e                	je     80215f <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8020f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8020f6:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  8020fd:	00 00 00 
  802100:	ff d0                	call   *%rax
  802102:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802109:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80210b:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802111:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802116:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80211d:	00 00 00 
  802120:	44 89 e6             	mov    %r12d,%esi
  802123:	89 c7                	mov    %eax,%edi
  802125:	48 b8 92 2f 80 00 00 	movabs $0x802f92,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802131:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802138:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802139:	b9 00 00 00 00       	mov    $0x0,%ecx
  80213e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802142:	48 89 de             	mov    %rbx,%rsi
  802145:	bf 00 00 00 00       	mov    $0x0,%edi
  80214a:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  802151:	00 00 00 
  802154:	ff d0                	call   *%rax
}
  802156:	48 83 c4 10          	add    $0x10,%rsp
  80215a:	5b                   	pop    %rbx
  80215b:	41 5c                	pop    %r12
  80215d:	5d                   	pop    %rbp
  80215e:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80215f:	bf 03 00 00 00       	mov    $0x3,%edi
  802164:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  80216b:	00 00 00 
  80216e:	ff d0                	call   *%rax
  802170:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802177:	00 00 
  802179:	e9 73 ff ff ff       	jmp    8020f1 <fsipc+0x24>

000000000080217e <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80217e:	f3 0f 1e fa          	endbr64
  802182:	55                   	push   %rbp
  802183:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802186:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80218d:	00 00 00 
  802190:	8b 57 0c             	mov    0xc(%rdi),%edx
  802193:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802195:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802198:	be 00 00 00 00       	mov    $0x0,%esi
  80219d:	bf 02 00 00 00       	mov    $0x2,%edi
  8021a2:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	call   *%rax
}
  8021ae:	5d                   	pop    %rbp
  8021af:	c3                   	ret

00000000008021b0 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8021b0:	f3 0f 1e fa          	endbr64
  8021b4:	55                   	push   %rbp
  8021b5:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021b8:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021bb:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021c2:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8021c4:	be 00 00 00 00       	mov    $0x0,%esi
  8021c9:	bf 06 00 00 00       	mov    $0x6,%edi
  8021ce:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  8021d5:	00 00 00 
  8021d8:	ff d0                	call   *%rax
}
  8021da:	5d                   	pop    %rbp
  8021db:	c3                   	ret

00000000008021dc <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8021dc:	f3 0f 1e fa          	endbr64
  8021e0:	55                   	push   %rbp
  8021e1:	48 89 e5             	mov    %rsp,%rbp
  8021e4:	41 54                	push   %r12
  8021e6:	53                   	push   %rbx
  8021e7:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021ea:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021ed:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021f4:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8021f6:	be 00 00 00 00       	mov    $0x0,%esi
  8021fb:	bf 05 00 00 00       	mov    $0x5,%edi
  802200:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  802207:	00 00 00 
  80220a:	ff d0                	call   *%rax
    if (res < 0) return res;
  80220c:	85 c0                	test   %eax,%eax
  80220e:	78 3d                	js     80224d <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802210:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802217:	00 00 00 
  80221a:	4c 89 e6             	mov    %r12,%rsi
  80221d:	48 89 df             	mov    %rbx,%rdi
  802220:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  802227:	00 00 00 
  80222a:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80222c:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802233:	00 
  802234:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80223a:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802241:	00 
  802242:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224d:	5b                   	pop    %rbx
  80224e:	41 5c                	pop    %r12
  802250:	5d                   	pop    %rbp
  802251:	c3                   	ret

0000000000802252 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802252:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802256:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80225d:	77 41                	ja     8022a0 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80225f:	55                   	push   %rbp
  802260:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802263:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80226a:	00 00 00 
  80226d:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802270:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802272:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802276:	48 8d 78 10          	lea    0x10(%rax),%rdi
  80227a:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802281:	00 00 00 
  802284:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802286:	be 00 00 00 00       	mov    $0x0,%esi
  80228b:	bf 04 00 00 00       	mov    $0x4,%edi
  802290:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  802297:	00 00 00 
  80229a:	ff d0                	call   *%rax
  80229c:	48 98                	cltq
}
  80229e:	5d                   	pop    %rbp
  80229f:	c3                   	ret
        return -E_INVAL;
  8022a0:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8022a7:	c3                   	ret

00000000008022a8 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8022a8:	f3 0f 1e fa          	endbr64
  8022ac:	55                   	push   %rbp
  8022ad:	48 89 e5             	mov    %rsp,%rbp
  8022b0:	41 55                	push   %r13
  8022b2:	41 54                	push   %r12
  8022b4:	53                   	push   %rbx
  8022b5:	48 83 ec 08          	sub    $0x8,%rsp
  8022b9:	49 89 f4             	mov    %rsi,%r12
  8022bc:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8022bf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022c6:	00 00 00 
  8022c9:	8b 57 0c             	mov    0xc(%rdi),%edx
  8022cc:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8022ce:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8022d2:	be 00 00 00 00       	mov    $0x0,%esi
  8022d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8022dc:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  8022e3:	00 00 00 
  8022e6:	ff d0                	call   *%rax
  8022e8:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8022eb:	4d 85 ed             	test   %r13,%r13
  8022ee:	78 2a                	js     80231a <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8022f0:	4c 89 ea             	mov    %r13,%rdx
  8022f3:	4c 39 eb             	cmp    %r13,%rbx
  8022f6:	72 30                	jb     802328 <devfile_read+0x80>
  8022f8:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8022ff:	7f 27                	jg     802328 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802301:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802308:	00 00 00 
  80230b:	4c 89 e7             	mov    %r12,%rdi
  80230e:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802315:	00 00 00 
  802318:	ff d0                	call   *%rax
}
  80231a:	4c 89 e8             	mov    %r13,%rax
  80231d:	48 83 c4 08          	add    $0x8,%rsp
  802321:	5b                   	pop    %rbx
  802322:	41 5c                	pop    %r12
  802324:	41 5d                	pop    %r13
  802326:	5d                   	pop    %rbp
  802327:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802328:	48 b9 56 42 80 00 00 	movabs $0x804256,%rcx
  80232f:	00 00 00 
  802332:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
  802339:	00 00 00 
  80233c:	be 7b 00 00 00       	mov    $0x7b,%esi
  802341:	48 bf 73 42 80 00 00 	movabs $0x804273,%rdi
  802348:	00 00 00 
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	49 b8 10 02 80 00 00 	movabs $0x800210,%r8
  802357:	00 00 00 
  80235a:	41 ff d0             	call   *%r8

000000000080235d <open>:
open(const char *path, int mode) {
  80235d:	f3 0f 1e fa          	endbr64
  802361:	55                   	push   %rbp
  802362:	48 89 e5             	mov    %rsp,%rbp
  802365:	41 55                	push   %r13
  802367:	41 54                	push   %r12
  802369:	53                   	push   %rbx
  80236a:	48 83 ec 18          	sub    $0x18,%rsp
  80236e:	49 89 fc             	mov    %rdi,%r12
  802371:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802374:	48 b8 70 0c 80 00 00 	movabs $0x800c70,%rax
  80237b:	00 00 00 
  80237e:	ff d0                	call   *%rax
  802380:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802386:	0f 87 8a 00 00 00    	ja     802416 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80238c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802390:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802397:	00 00 00 
  80239a:	ff d0                	call   *%rax
  80239c:	89 c3                	mov    %eax,%ebx
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	78 50                	js     8023f2 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8023a2:	4c 89 e6             	mov    %r12,%rsi
  8023a5:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8023ac:	00 00 00 
  8023af:	48 89 df             	mov    %rbx,%rdi
  8023b2:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8023be:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8023c5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8023ce:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	call   *%rax
  8023da:	89 c3                	mov    %eax,%ebx
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	78 1f                	js     8023ff <open+0xa2>
    return fd2num(fd);
  8023e0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023e4:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  8023eb:	00 00 00 
  8023ee:	ff d0                	call   *%rax
  8023f0:	89 c3                	mov    %eax,%ebx
}
  8023f2:	89 d8                	mov    %ebx,%eax
  8023f4:	48 83 c4 18          	add    $0x18,%rsp
  8023f8:	5b                   	pop    %rbx
  8023f9:	41 5c                	pop    %r12
  8023fb:	41 5d                	pop    %r13
  8023fd:	5d                   	pop    %rbp
  8023fe:	c3                   	ret
        fd_close(fd, 0);
  8023ff:	be 00 00 00 00       	mov    $0x0,%esi
  802404:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802408:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  80240f:	00 00 00 
  802412:	ff d0                	call   *%rax
        return res;
  802414:	eb dc                	jmp    8023f2 <open+0x95>
        return -E_BAD_PATH;
  802416:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80241b:	eb d5                	jmp    8023f2 <open+0x95>

000000000080241d <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80241d:	f3 0f 1e fa          	endbr64
  802421:	55                   	push   %rbp
  802422:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802425:	be 00 00 00 00       	mov    $0x0,%esi
  80242a:	bf 08 00 00 00       	mov    $0x8,%edi
  80242f:	48 b8 cd 20 80 00 00 	movabs $0x8020cd,%rax
  802436:	00 00 00 
  802439:	ff d0                	call   *%rax
}
  80243b:	5d                   	pop    %rbp
  80243c:	c3                   	ret

000000000080243d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80243d:	f3 0f 1e fa          	endbr64
  802441:	55                   	push   %rbp
  802442:	48 89 e5             	mov    %rsp,%rbp
  802445:	41 54                	push   %r12
  802447:	53                   	push   %rbx
  802448:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80244b:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  802452:	00 00 00 
  802455:	ff d0                	call   *%rax
  802457:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80245a:	48 be 7e 42 80 00 00 	movabs $0x80427e,%rsi
  802461:	00 00 00 
  802464:	48 89 df             	mov    %rbx,%rdi
  802467:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  80246e:	00 00 00 
  802471:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802473:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802478:	41 2b 04 24          	sub    (%r12),%eax
  80247c:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802482:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802489:	00 00 00 
    stat->st_dev = &devpipe;
  80248c:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802493:	00 00 00 
  802496:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	5b                   	pop    %rbx
  8024a3:	41 5c                	pop    %r12
  8024a5:	5d                   	pop    %rbp
  8024a6:	c3                   	ret

00000000008024a7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8024a7:	f3 0f 1e fa          	endbr64
  8024ab:	55                   	push   %rbp
  8024ac:	48 89 e5             	mov    %rsp,%rbp
  8024af:	41 54                	push   %r12
  8024b1:	53                   	push   %rbx
  8024b2:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8024b5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ba:	48 89 fe             	mov    %rdi,%rsi
  8024bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c2:	49 bc fa 13 80 00 00 	movabs $0x8013fa,%r12
  8024c9:	00 00 00 
  8024cc:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8024cf:	48 89 df             	mov    %rbx,%rdi
  8024d2:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	call   *%rax
  8024de:	48 89 c6             	mov    %rax,%rsi
  8024e1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024eb:	41 ff d4             	call   *%r12
}
  8024ee:	5b                   	pop    %rbx
  8024ef:	41 5c                	pop    %r12
  8024f1:	5d                   	pop    %rbp
  8024f2:	c3                   	ret

00000000008024f3 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024f3:	f3 0f 1e fa          	endbr64
  8024f7:	55                   	push   %rbp
  8024f8:	48 89 e5             	mov    %rsp,%rbp
  8024fb:	41 57                	push   %r15
  8024fd:	41 56                	push   %r14
  8024ff:	41 55                	push   %r13
  802501:	41 54                	push   %r12
  802503:	53                   	push   %rbx
  802504:	48 83 ec 18          	sub    $0x18,%rsp
  802508:	49 89 fc             	mov    %rdi,%r12
  80250b:	49 89 f5             	mov    %rsi,%r13
  80250e:	49 89 d7             	mov    %rdx,%r15
  802511:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802515:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802521:	4d 85 ff             	test   %r15,%r15
  802524:	0f 84 af 00 00 00    	je     8025d9 <devpipe_write+0xe6>
  80252a:	48 89 c3             	mov    %rax,%rbx
  80252d:	4c 89 f8             	mov    %r15,%rax
  802530:	4d 89 ef             	mov    %r13,%r15
  802533:	4c 01 e8             	add    %r13,%rax
  802536:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80253a:	49 bd 8a 12 80 00 00 	movabs $0x80128a,%r13
  802541:	00 00 00 
            sys_yield();
  802544:	49 be 1f 12 80 00 00 	movabs $0x80121f,%r14
  80254b:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80254e:	8b 73 04             	mov    0x4(%rbx),%esi
  802551:	48 63 ce             	movslq %esi,%rcx
  802554:	48 63 03             	movslq (%rbx),%rax
  802557:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80255d:	48 39 c1             	cmp    %rax,%rcx
  802560:	72 2e                	jb     802590 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802562:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802567:	48 89 da             	mov    %rbx,%rdx
  80256a:	be 00 10 00 00       	mov    $0x1000,%esi
  80256f:	4c 89 e7             	mov    %r12,%rdi
  802572:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802575:	85 c0                	test   %eax,%eax
  802577:	74 66                	je     8025df <devpipe_write+0xec>
            sys_yield();
  802579:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80257c:	8b 73 04             	mov    0x4(%rbx),%esi
  80257f:	48 63 ce             	movslq %esi,%rcx
  802582:	48 63 03             	movslq (%rbx),%rax
  802585:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80258b:	48 39 c1             	cmp    %rax,%rcx
  80258e:	73 d2                	jae    802562 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802590:	41 0f b6 3f          	movzbl (%r15),%edi
  802594:	48 89 ca             	mov    %rcx,%rdx
  802597:	48 c1 ea 03          	shr    $0x3,%rdx
  80259b:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8025a2:	08 10 20 
  8025a5:	48 f7 e2             	mul    %rdx
  8025a8:	48 c1 ea 06          	shr    $0x6,%rdx
  8025ac:	48 89 d0             	mov    %rdx,%rax
  8025af:	48 c1 e0 09          	shl    $0x9,%rax
  8025b3:	48 29 d0             	sub    %rdx,%rax
  8025b6:	48 c1 e0 03          	shl    $0x3,%rax
  8025ba:	48 29 c1             	sub    %rax,%rcx
  8025bd:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8025c2:	83 c6 01             	add    $0x1,%esi
  8025c5:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025c8:	49 83 c7 01          	add    $0x1,%r15
  8025cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8025d0:	49 39 c7             	cmp    %rax,%r15
  8025d3:	0f 85 75 ff ff ff    	jne    80254e <devpipe_write+0x5b>
    return n;
  8025d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8025dd:	eb 05                	jmp    8025e4 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e4:	48 83 c4 18          	add    $0x18,%rsp
  8025e8:	5b                   	pop    %rbx
  8025e9:	41 5c                	pop    %r12
  8025eb:	41 5d                	pop    %r13
  8025ed:	41 5e                	pop    %r14
  8025ef:	41 5f                	pop    %r15
  8025f1:	5d                   	pop    %rbp
  8025f2:	c3                   	ret

00000000008025f3 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025f3:	f3 0f 1e fa          	endbr64
  8025f7:	55                   	push   %rbp
  8025f8:	48 89 e5             	mov    %rsp,%rbp
  8025fb:	41 57                	push   %r15
  8025fd:	41 56                	push   %r14
  8025ff:	41 55                	push   %r13
  802601:	41 54                	push   %r12
  802603:	53                   	push   %rbx
  802604:	48 83 ec 18          	sub    $0x18,%rsp
  802608:	49 89 fc             	mov    %rdi,%r12
  80260b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80260f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802613:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  80261a:	00 00 00 
  80261d:	ff d0                	call   *%rax
  80261f:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802622:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802628:	49 bd 8a 12 80 00 00 	movabs $0x80128a,%r13
  80262f:	00 00 00 
            sys_yield();
  802632:	49 be 1f 12 80 00 00 	movabs $0x80121f,%r14
  802639:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80263c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802641:	74 7d                	je     8026c0 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802643:	8b 03                	mov    (%rbx),%eax
  802645:	3b 43 04             	cmp    0x4(%rbx),%eax
  802648:	75 26                	jne    802670 <devpipe_read+0x7d>
            if (i > 0) return i;
  80264a:	4d 85 ff             	test   %r15,%r15
  80264d:	75 77                	jne    8026c6 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80264f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802654:	48 89 da             	mov    %rbx,%rdx
  802657:	be 00 10 00 00       	mov    $0x1000,%esi
  80265c:	4c 89 e7             	mov    %r12,%rdi
  80265f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802662:	85 c0                	test   %eax,%eax
  802664:	74 72                	je     8026d8 <devpipe_read+0xe5>
            sys_yield();
  802666:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802669:	8b 03                	mov    (%rbx),%eax
  80266b:	3b 43 04             	cmp    0x4(%rbx),%eax
  80266e:	74 df                	je     80264f <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802670:	48 63 c8             	movslq %eax,%rcx
  802673:	48 89 ca             	mov    %rcx,%rdx
  802676:	48 c1 ea 03          	shr    $0x3,%rdx
  80267a:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802681:	08 10 20 
  802684:	48 89 d0             	mov    %rdx,%rax
  802687:	48 f7 e6             	mul    %rsi
  80268a:	48 c1 ea 06          	shr    $0x6,%rdx
  80268e:	48 89 d0             	mov    %rdx,%rax
  802691:	48 c1 e0 09          	shl    $0x9,%rax
  802695:	48 29 d0             	sub    %rdx,%rax
  802698:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80269f:	00 
  8026a0:	48 89 c8             	mov    %rcx,%rax
  8026a3:	48 29 d0             	sub    %rdx,%rax
  8026a6:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8026ab:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8026af:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8026b3:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8026b6:	49 83 c7 01          	add    $0x1,%r15
  8026ba:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8026be:	75 83                	jne    802643 <devpipe_read+0x50>
    return n;
  8026c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026c4:	eb 03                	jmp    8026c9 <devpipe_read+0xd6>
            if (i > 0) return i;
  8026c6:	4c 89 f8             	mov    %r15,%rax
}
  8026c9:	48 83 c4 18          	add    $0x18,%rsp
  8026cd:	5b                   	pop    %rbx
  8026ce:	41 5c                	pop    %r12
  8026d0:	41 5d                	pop    %r13
  8026d2:	41 5e                	pop    %r14
  8026d4:	41 5f                	pop    %r15
  8026d6:	5d                   	pop    %rbp
  8026d7:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	eb ea                	jmp    8026c9 <devpipe_read+0xd6>

00000000008026df <pipe>:
pipe(int pfd[2]) {
  8026df:	f3 0f 1e fa          	endbr64
  8026e3:	55                   	push   %rbp
  8026e4:	48 89 e5             	mov    %rsp,%rbp
  8026e7:	41 55                	push   %r13
  8026e9:	41 54                	push   %r12
  8026eb:	53                   	push   %rbx
  8026ec:	48 83 ec 18          	sub    $0x18,%rsp
  8026f0:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026f3:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026f7:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  8026fe:	00 00 00 
  802701:	ff d0                	call   *%rax
  802703:	89 c3                	mov    %eax,%ebx
  802705:	85 c0                	test   %eax,%eax
  802707:	0f 88 a0 01 00 00    	js     8028ad <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80270d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802712:	ba 00 10 00 00       	mov    $0x1000,%edx
  802717:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80271b:	bf 00 00 00 00       	mov    $0x0,%edi
  802720:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  802727:	00 00 00 
  80272a:	ff d0                	call   *%rax
  80272c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80272e:	85 c0                	test   %eax,%eax
  802730:	0f 88 77 01 00 00    	js     8028ad <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802736:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80273a:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802741:	00 00 00 
  802744:	ff d0                	call   *%rax
  802746:	89 c3                	mov    %eax,%ebx
  802748:	85 c0                	test   %eax,%eax
  80274a:	0f 88 43 01 00 00    	js     802893 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802750:	b9 46 00 00 00       	mov    $0x46,%ecx
  802755:	ba 00 10 00 00       	mov    $0x1000,%edx
  80275a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80275e:	bf 00 00 00 00       	mov    $0x0,%edi
  802763:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  80276a:	00 00 00 
  80276d:	ff d0                	call   *%rax
  80276f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802771:	85 c0                	test   %eax,%eax
  802773:	0f 88 1a 01 00 00    	js     802893 <pipe+0x1b4>
    va = fd2data(fd0);
  802779:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80277d:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  802784:	00 00 00 
  802787:	ff d0                	call   *%rax
  802789:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80278c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802791:	ba 00 10 00 00       	mov    $0x1000,%edx
  802796:	48 89 c6             	mov    %rax,%rsi
  802799:	bf 00 00 00 00       	mov    $0x0,%edi
  80279e:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  8027a5:	00 00 00 
  8027a8:	ff d0                	call   *%rax
  8027aa:	89 c3                	mov    %eax,%ebx
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	0f 88 c5 00 00 00    	js     802879 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8027b4:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027b8:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	call   *%rax
  8027c4:	48 89 c1             	mov    %rax,%rcx
  8027c7:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8027cd:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8027d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d8:	4c 89 ee             	mov    %r13,%rsi
  8027db:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e0:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	call   *%rax
  8027ec:	89 c3                	mov    %eax,%ebx
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	78 6e                	js     802860 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027f2:	be 00 10 00 00       	mov    $0x1000,%esi
  8027f7:	4c 89 ef             	mov    %r13,%rdi
  8027fa:	48 b8 54 12 80 00 00 	movabs $0x801254,%rax
  802801:	00 00 00 
  802804:	ff d0                	call   *%rax
  802806:	83 f8 02             	cmp    $0x2,%eax
  802809:	0f 85 ab 00 00 00    	jne    8028ba <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80280f:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802816:	00 00 
  802818:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80281c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80281e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802822:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802829:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80282d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80282f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802833:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80283a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80283e:	48 bb 92 19 80 00 00 	movabs $0x801992,%rbx
  802845:	00 00 00 
  802848:	ff d3                	call   *%rbx
  80284a:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80284e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802852:	ff d3                	call   *%rbx
  802854:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802859:	bb 00 00 00 00       	mov    $0x0,%ebx
  80285e:	eb 4d                	jmp    8028ad <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802860:	ba 00 10 00 00       	mov    $0x1000,%edx
  802865:	4c 89 ee             	mov    %r13,%rsi
  802868:	bf 00 00 00 00       	mov    $0x0,%edi
  80286d:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  802874:	00 00 00 
  802877:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802879:	ba 00 10 00 00       	mov    $0x1000,%edx
  80287e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802882:	bf 00 00 00 00       	mov    $0x0,%edi
  802887:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  80288e:	00 00 00 
  802891:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802893:	ba 00 10 00 00       	mov    $0x1000,%edx
  802898:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80289c:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a1:	48 b8 fa 13 80 00 00 	movabs $0x8013fa,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	call   *%rax
}
  8028ad:	89 d8                	mov    %ebx,%eax
  8028af:	48 83 c4 18          	add    $0x18,%rsp
  8028b3:	5b                   	pop    %rbx
  8028b4:	41 5c                	pop    %r12
  8028b6:	41 5d                	pop    %r13
  8028b8:	5d                   	pop    %rbp
  8028b9:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8028ba:	48 b9 f0 43 80 00 00 	movabs $0x8043f0,%rcx
  8028c1:	00 00 00 
  8028c4:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
  8028cb:	00 00 00 
  8028ce:	be 2e 00 00 00       	mov    $0x2e,%esi
  8028d3:	48 bf 85 42 80 00 00 	movabs $0x804285,%rdi
  8028da:	00 00 00 
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	49 b8 10 02 80 00 00 	movabs $0x800210,%r8
  8028e9:	00 00 00 
  8028ec:	41 ff d0             	call   *%r8

00000000008028ef <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028ef:	f3 0f 1e fa          	endbr64
  8028f3:	55                   	push   %rbp
  8028f4:	48 89 e5             	mov    %rsp,%rbp
  8028f7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028fb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028ff:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  802906:	00 00 00 
  802909:	ff d0                	call   *%rax
    if (res < 0) return res;
  80290b:	85 c0                	test   %eax,%eax
  80290d:	78 35                	js     802944 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80290f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802913:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	call   *%rax
  80291f:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802922:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802927:	be 00 10 00 00       	mov    $0x1000,%esi
  80292c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802930:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  802937:	00 00 00 
  80293a:	ff d0                	call   *%rax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	0f 94 c0             	sete   %al
  802941:	0f b6 c0             	movzbl %al,%eax
}
  802944:	c9                   	leave
  802945:	c3                   	ret

0000000000802946 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802946:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80294a:	48 89 f8             	mov    %rdi,%rax
  80294d:	48 c1 e8 27          	shr    $0x27,%rax
  802951:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802958:	7f 00 00 
  80295b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80295f:	f6 c2 01             	test   $0x1,%dl
  802962:	74 6d                	je     8029d1 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802964:	48 89 f8             	mov    %rdi,%rax
  802967:	48 c1 e8 1e          	shr    $0x1e,%rax
  80296b:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802972:	7f 00 00 
  802975:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802979:	f6 c2 01             	test   $0x1,%dl
  80297c:	74 62                	je     8029e0 <get_uvpt_entry+0x9a>
  80297e:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802985:	7f 00 00 
  802988:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80298c:	f6 c2 80             	test   $0x80,%dl
  80298f:	75 4f                	jne    8029e0 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802991:	48 89 f8             	mov    %rdi,%rax
  802994:	48 c1 e8 15          	shr    $0x15,%rax
  802998:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80299f:	7f 00 00 
  8029a2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029a6:	f6 c2 01             	test   $0x1,%dl
  8029a9:	74 44                	je     8029ef <get_uvpt_entry+0xa9>
  8029ab:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029b2:	7f 00 00 
  8029b5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029b9:	f6 c2 80             	test   $0x80,%dl
  8029bc:	75 31                	jne    8029ef <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8029be:	48 c1 ef 0c          	shr    $0xc,%rdi
  8029c2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029c9:	7f 00 00 
  8029cc:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8029d0:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029d1:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029d8:	7f 00 00 
  8029db:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029df:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029e0:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029e7:	7f 00 00 
  8029ea:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029ee:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029ef:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029f6:	7f 00 00 
  8029f9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029fd:	c3                   	ret

00000000008029fe <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8029fe:	f3 0f 1e fa          	endbr64
  802a02:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a05:	48 89 f9             	mov    %rdi,%rcx
  802a08:	48 c1 e9 27          	shr    $0x27,%rcx
  802a0c:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802a13:	7f 00 00 
  802a16:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802a1a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a21:	f6 c1 01             	test   $0x1,%cl
  802a24:	0f 84 b2 00 00 00    	je     802adc <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a2a:	48 89 f9             	mov    %rdi,%rcx
  802a2d:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802a31:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a38:	7f 00 00 
  802a3b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a3f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a46:	40 f6 c6 01          	test   $0x1,%sil
  802a4a:	0f 84 8c 00 00 00    	je     802adc <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802a50:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a57:	7f 00 00 
  802a5a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a5e:	a8 80                	test   $0x80,%al
  802a60:	75 7b                	jne    802add <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802a62:	48 89 f9             	mov    %rdi,%rcx
  802a65:	48 c1 e9 15          	shr    $0x15,%rcx
  802a69:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a70:	7f 00 00 
  802a73:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a77:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802a7e:	40 f6 c6 01          	test   $0x1,%sil
  802a82:	74 58                	je     802adc <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802a84:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a8b:	7f 00 00 
  802a8e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a92:	a8 80                	test   $0x80,%al
  802a94:	75 6c                	jne    802b02 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802a96:	48 89 f9             	mov    %rdi,%rcx
  802a99:	48 c1 e9 0c          	shr    $0xc,%rcx
  802a9d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802aa4:	7f 00 00 
  802aa7:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802aab:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802ab2:	40 f6 c6 01          	test   $0x1,%sil
  802ab6:	74 24                	je     802adc <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802ab8:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802abf:	7f 00 00 
  802ac2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ac6:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802acd:	ff ff 7f 
  802ad0:	48 21 c8             	and    %rcx,%rax
  802ad3:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802ad9:	48 09 d0             	or     %rdx,%rax
}
  802adc:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802add:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ae4:	7f 00 00 
  802ae7:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802aeb:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802af2:	ff ff 7f 
  802af5:	48 21 c8             	and    %rcx,%rax
  802af8:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802afe:	48 01 d0             	add    %rdx,%rax
  802b01:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802b02:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b09:	7f 00 00 
  802b0c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b10:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b17:	ff ff 7f 
  802b1a:	48 21 c8             	and    %rcx,%rax
  802b1d:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802b23:	48 01 d0             	add    %rdx,%rax
  802b26:	c3                   	ret

0000000000802b27 <get_prot>:

int
get_prot(void *va) {
  802b27:	f3 0f 1e fa          	endbr64
  802b2b:	55                   	push   %rbp
  802b2c:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b2f:	48 b8 46 29 80 00 00 	movabs $0x802946,%rax
  802b36:	00 00 00 
  802b39:	ff d0                	call   *%rax
  802b3b:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802b3e:	83 e0 01             	and    $0x1,%eax
  802b41:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802b44:	89 d1                	mov    %edx,%ecx
  802b46:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802b4c:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b4e:	89 c1                	mov    %eax,%ecx
  802b50:	83 c9 02             	or     $0x2,%ecx
  802b53:	f6 c2 02             	test   $0x2,%dl
  802b56:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b59:	89 c1                	mov    %eax,%ecx
  802b5b:	83 c9 01             	or     $0x1,%ecx
  802b5e:	48 85 d2             	test   %rdx,%rdx
  802b61:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b64:	89 c1                	mov    %eax,%ecx
  802b66:	83 c9 40             	or     $0x40,%ecx
  802b69:	f6 c6 04             	test   $0x4,%dh
  802b6c:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b6f:	5d                   	pop    %rbp
  802b70:	c3                   	ret

0000000000802b71 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b71:	f3 0f 1e fa          	endbr64
  802b75:	55                   	push   %rbp
  802b76:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b79:	48 b8 46 29 80 00 00 	movabs $0x802946,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b85:	48 c1 e8 06          	shr    $0x6,%rax
  802b89:	83 e0 01             	and    $0x1,%eax
}
  802b8c:	5d                   	pop    %rbp
  802b8d:	c3                   	ret

0000000000802b8e <is_page_present>:

bool
is_page_present(void *va) {
  802b8e:	f3 0f 1e fa          	endbr64
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b96:	48 b8 46 29 80 00 00 	movabs $0x802946,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	call   *%rax
  802ba2:	83 e0 01             	and    $0x1,%eax
}
  802ba5:	5d                   	pop    %rbp
  802ba6:	c3                   	ret

0000000000802ba7 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802ba7:	f3 0f 1e fa          	endbr64
  802bab:	55                   	push   %rbp
  802bac:	48 89 e5             	mov    %rsp,%rbp
  802baf:	41 57                	push   %r15
  802bb1:	41 56                	push   %r14
  802bb3:	41 55                	push   %r13
  802bb5:	41 54                	push   %r12
  802bb7:	53                   	push   %rbx
  802bb8:	48 83 ec 18          	sub    $0x18,%rsp
  802bbc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802bc0:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802bc4:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802bc9:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802bd0:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802bd3:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802bda:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802bdd:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802be4:	00 00 00 
  802be7:	eb 73                	jmp    802c5c <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802be9:	48 89 d8             	mov    %rbx,%rax
  802bec:	48 c1 e8 15          	shr    $0x15,%rax
  802bf0:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802bf7:	7f 00 00 
  802bfa:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802bfe:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c04:	f6 c2 01             	test   $0x1,%dl
  802c07:	74 4b                	je     802c54 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802c09:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802c0d:	f6 c2 80             	test   $0x80,%dl
  802c10:	74 11                	je     802c23 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802c12:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802c16:	f6 c4 04             	test   $0x4,%ah
  802c19:	74 39                	je     802c54 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802c1b:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802c21:	eb 20                	jmp    802c43 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c23:	48 89 da             	mov    %rbx,%rdx
  802c26:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c2a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802c31:	7f 00 00 
  802c34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802c38:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c3e:	f6 c4 04             	test   $0x4,%ah
  802c41:	74 11                	je     802c54 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802c43:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802c47:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c4b:	48 89 df             	mov    %rbx,%rdi
  802c4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c52:	ff d0                	call   *%rax
    next:
        va += size;
  802c54:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802c57:	49 39 df             	cmp    %rbx,%r15
  802c5a:	72 3e                	jb     802c9a <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c5c:	49 8b 06             	mov    (%r14),%rax
  802c5f:	a8 01                	test   $0x1,%al
  802c61:	74 37                	je     802c9a <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c63:	48 89 d8             	mov    %rbx,%rax
  802c66:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c6a:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802c6f:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c75:	f6 c2 01             	test   $0x1,%dl
  802c78:	74 da                	je     802c54 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802c7a:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802c7f:	f6 c2 80             	test   $0x80,%dl
  802c82:	0f 84 61 ff ff ff    	je     802be9 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802c88:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c8d:	f6 c4 04             	test   $0x4,%ah
  802c90:	74 c2                	je     802c54 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802c92:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802c98:	eb a9                	jmp    802c43 <foreach_shared_region+0x9c>
    }
    return res;
}
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9f:	48 83 c4 18          	add    $0x18,%rsp
  802ca3:	5b                   	pop    %rbx
  802ca4:	41 5c                	pop    %r12
  802ca6:	41 5d                	pop    %r13
  802ca8:	41 5e                	pop    %r14
  802caa:	41 5f                	pop    %r15
  802cac:	5d                   	pop    %rbp
  802cad:	c3                   	ret

0000000000802cae <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802cae:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb7:	c3                   	ret

0000000000802cb8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802cb8:	f3 0f 1e fa          	endbr64
  802cbc:	55                   	push   %rbp
  802cbd:	48 89 e5             	mov    %rsp,%rbp
  802cc0:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802cc3:	48 be 95 42 80 00 00 	movabs $0x804295,%rsi
  802cca:	00 00 00 
  802ccd:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	call   *%rax
    return 0;
}
  802cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cde:	5d                   	pop    %rbp
  802cdf:	c3                   	ret

0000000000802ce0 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802ce0:	f3 0f 1e fa          	endbr64
  802ce4:	55                   	push   %rbp
  802ce5:	48 89 e5             	mov    %rsp,%rbp
  802ce8:	41 57                	push   %r15
  802cea:	41 56                	push   %r14
  802cec:	41 55                	push   %r13
  802cee:	41 54                	push   %r12
  802cf0:	53                   	push   %rbx
  802cf1:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802cf8:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cff:	48 85 d2             	test   %rdx,%rdx
  802d02:	74 7a                	je     802d7e <devcons_write+0x9e>
  802d04:	49 89 d6             	mov    %rdx,%r14
  802d07:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d0d:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d12:	49 bf d0 0e 80 00 00 	movabs $0x800ed0,%r15
  802d19:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d1c:	4c 89 f3             	mov    %r14,%rbx
  802d1f:	48 29 f3             	sub    %rsi,%rbx
  802d22:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d27:	48 39 c3             	cmp    %rax,%rbx
  802d2a:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802d2e:	4c 63 eb             	movslq %ebx,%r13
  802d31:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802d38:	48 01 c6             	add    %rax,%rsi
  802d3b:	4c 89 ea             	mov    %r13,%rdx
  802d3e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d45:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802d48:	4c 89 ee             	mov    %r13,%rsi
  802d4b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d52:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d5e:	41 01 dc             	add    %ebx,%r12d
  802d61:	49 63 f4             	movslq %r12d,%rsi
  802d64:	4c 39 f6             	cmp    %r14,%rsi
  802d67:	72 b3                	jb     802d1c <devcons_write+0x3c>
    return res;
  802d69:	49 63 c4             	movslq %r12d,%rax
}
  802d6c:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d73:	5b                   	pop    %rbx
  802d74:	41 5c                	pop    %r12
  802d76:	41 5d                	pop    %r13
  802d78:	41 5e                	pop    %r14
  802d7a:	41 5f                	pop    %r15
  802d7c:	5d                   	pop    %rbp
  802d7d:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802d7e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d84:	eb e3                	jmp    802d69 <devcons_write+0x89>

0000000000802d86 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d86:	f3 0f 1e fa          	endbr64
  802d8a:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d92:	48 85 c0             	test   %rax,%rax
  802d95:	74 55                	je     802dec <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d97:	55                   	push   %rbp
  802d98:	48 89 e5             	mov    %rsp,%rbp
  802d9b:	41 55                	push   %r13
  802d9d:	41 54                	push   %r12
  802d9f:	53                   	push   %rbx
  802da0:	48 83 ec 08          	sub    $0x8,%rsp
  802da4:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802da7:	48 bb 46 11 80 00 00 	movabs $0x801146,%rbx
  802dae:	00 00 00 
  802db1:	49 bc 1f 12 80 00 00 	movabs $0x80121f,%r12
  802db8:	00 00 00 
  802dbb:	eb 03                	jmp    802dc0 <devcons_read+0x3a>
  802dbd:	41 ff d4             	call   *%r12
  802dc0:	ff d3                	call   *%rbx
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 f7                	je     802dbd <devcons_read+0x37>
    if (c < 0) return c;
  802dc6:	48 63 d0             	movslq %eax,%rdx
  802dc9:	78 13                	js     802dde <devcons_read+0x58>
    if (c == 0x04) return 0;
  802dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd0:	83 f8 04             	cmp    $0x4,%eax
  802dd3:	74 09                	je     802dde <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802dd5:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802dd9:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802dde:	48 89 d0             	mov    %rdx,%rax
  802de1:	48 83 c4 08          	add    $0x8,%rsp
  802de5:	5b                   	pop    %rbx
  802de6:	41 5c                	pop    %r12
  802de8:	41 5d                	pop    %r13
  802dea:	5d                   	pop    %rbp
  802deb:	c3                   	ret
  802dec:	48 89 d0             	mov    %rdx,%rax
  802def:	c3                   	ret

0000000000802df0 <cputchar>:
cputchar(int ch) {
  802df0:	f3 0f 1e fa          	endbr64
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802dfc:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e00:	be 01 00 00 00       	mov    $0x1,%esi
  802e05:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e09:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	call   *%rax
}
  802e15:	c9                   	leave
  802e16:	c3                   	ret

0000000000802e17 <getchar>:
getchar(void) {
  802e17:	f3 0f 1e fa          	endbr64
  802e1b:	55                   	push   %rbp
  802e1c:	48 89 e5             	mov    %rsp,%rbp
  802e1f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e23:	ba 01 00 00 00       	mov    $0x1,%edx
  802e28:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e31:	48 b8 27 1d 80 00 00 	movabs $0x801d27,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	call   *%rax
  802e3d:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	78 06                	js     802e49 <getchar+0x32>
  802e43:	74 08                	je     802e4d <getchar+0x36>
  802e45:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e49:	89 d0                	mov    %edx,%eax
  802e4b:	c9                   	leave
  802e4c:	c3                   	ret
    return res < 0 ? res : res ? c :
  802e4d:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e52:	eb f5                	jmp    802e49 <getchar+0x32>

0000000000802e54 <iscons>:
iscons(int fdnum) {
  802e54:	f3 0f 1e fa          	endbr64
  802e58:	55                   	push   %rbp
  802e59:	48 89 e5             	mov    %rsp,%rbp
  802e5c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e60:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e64:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  802e6b:	00 00 00 
  802e6e:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e70:	85 c0                	test   %eax,%eax
  802e72:	78 18                	js     802e8c <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802e74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e78:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802e7f:	00 00 00 
  802e82:	8b 00                	mov    (%rax),%eax
  802e84:	39 02                	cmp    %eax,(%rdx)
  802e86:	0f 94 c0             	sete   %al
  802e89:	0f b6 c0             	movzbl %al,%eax
}
  802e8c:	c9                   	leave
  802e8d:	c3                   	ret

0000000000802e8e <opencons>:
opencons(void) {
  802e8e:	f3 0f 1e fa          	endbr64
  802e92:	55                   	push   %rbp
  802e93:	48 89 e5             	mov    %rsp,%rbp
  802e96:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e9a:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e9e:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	call   *%rax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	78 49                	js     802ef7 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802eae:	b9 46 00 00 00       	mov    $0x46,%ecx
  802eb3:	ba 00 10 00 00       	mov    $0x1000,%edx
  802eb8:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec1:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	call   *%rax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	78 26                	js     802ef7 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802ed1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed5:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802edc:	00 00 
  802ede:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ee0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ee4:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802eeb:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  802ef2:	00 00 00 
  802ef5:	ff d0                	call   *%rax
}
  802ef7:	c9                   	leave
  802ef8:	c3                   	ret

0000000000802ef9 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ef9:	f3 0f 1e fa          	endbr64
  802efd:	55                   	push   %rbp
  802efe:	48 89 e5             	mov    %rsp,%rbp
  802f01:	41 54                	push   %r12
  802f03:	53                   	push   %rbx
  802f04:	48 89 fb             	mov    %rdi,%rbx
  802f07:	48 89 f7             	mov    %rsi,%rdi
  802f0a:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f0d:	48 85 f6             	test   %rsi,%rsi
  802f10:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f17:	00 00 00 
  802f1a:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802f1e:	be 00 10 00 00       	mov    $0x1000,%esi
  802f23:	48 b8 dc 15 80 00 00 	movabs $0x8015dc,%rax
  802f2a:	00 00 00 
  802f2d:	ff d0                	call   *%rax
    if (res < 0) {
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	78 45                	js     802f78 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802f33:	48 85 db             	test   %rbx,%rbx
  802f36:	74 12                	je     802f4a <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802f38:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f3f:	00 00 00 
  802f42:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802f48:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802f4a:	4d 85 e4             	test   %r12,%r12
  802f4d:	74 14                	je     802f63 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802f4f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f56:	00 00 00 
  802f59:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802f5f:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802f63:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f6a:	00 00 00 
  802f6d:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802f73:	5b                   	pop    %rbx
  802f74:	41 5c                	pop    %r12
  802f76:	5d                   	pop    %rbp
  802f77:	c3                   	ret
        if (from_env_store != NULL) {
  802f78:	48 85 db             	test   %rbx,%rbx
  802f7b:	74 06                	je     802f83 <ipc_recv+0x8a>
            *from_env_store = 0;
  802f7d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802f83:	4d 85 e4             	test   %r12,%r12
  802f86:	74 eb                	je     802f73 <ipc_recv+0x7a>
            *perm_store = 0;
  802f88:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802f8f:	00 
  802f90:	eb e1                	jmp    802f73 <ipc_recv+0x7a>

0000000000802f92 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802f92:	f3 0f 1e fa          	endbr64
  802f96:	55                   	push   %rbp
  802f97:	48 89 e5             	mov    %rsp,%rbp
  802f9a:	41 57                	push   %r15
  802f9c:	41 56                	push   %r14
  802f9e:	41 55                	push   %r13
  802fa0:	41 54                	push   %r12
  802fa2:	53                   	push   %rbx
  802fa3:	48 83 ec 18          	sub    $0x18,%rsp
  802fa7:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802faa:	48 89 d3             	mov    %rdx,%rbx
  802fad:	49 89 cc             	mov    %rcx,%r12
  802fb0:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802fb3:	48 85 d2             	test   %rdx,%rdx
  802fb6:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802fbd:	00 00 00 
  802fc0:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fc4:	89 f0                	mov    %esi,%eax
  802fc6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802fca:	48 89 da             	mov    %rbx,%rdx
  802fcd:	48 89 c6             	mov    %rax,%rsi
  802fd0:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	call   *%rax
    while (res < 0) {
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	79 65                	jns    803045 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802fe0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802fe3:	75 33                	jne    803018 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802fe5:	49 bf 1f 12 80 00 00 	movabs $0x80121f,%r15
  802fec:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fef:	49 be ac 15 80 00 00 	movabs $0x8015ac,%r14
  802ff6:	00 00 00 
        sys_yield();
  802ff9:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ffc:	45 89 e8             	mov    %r13d,%r8d
  802fff:	4c 89 e1             	mov    %r12,%rcx
  803002:	48 89 da             	mov    %rbx,%rdx
  803005:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803009:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  80300c:	41 ff d6             	call   *%r14
    while (res < 0) {
  80300f:	85 c0                	test   %eax,%eax
  803011:	79 32                	jns    803045 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803013:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803016:	74 e1                	je     802ff9 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803018:	89 c1                	mov    %eax,%ecx
  80301a:	48 ba a1 42 80 00 00 	movabs $0x8042a1,%rdx
  803021:	00 00 00 
  803024:	be 42 00 00 00       	mov    $0x42,%esi
  803029:	48 bf ac 42 80 00 00 	movabs $0x8042ac,%rdi
  803030:	00 00 00 
  803033:	b8 00 00 00 00       	mov    $0x0,%eax
  803038:	49 b8 10 02 80 00 00 	movabs $0x800210,%r8
  80303f:	00 00 00 
  803042:	41 ff d0             	call   *%r8
    }
}
  803045:	48 83 c4 18          	add    $0x18,%rsp
  803049:	5b                   	pop    %rbx
  80304a:	41 5c                	pop    %r12
  80304c:	41 5d                	pop    %r13
  80304e:	41 5e                	pop    %r14
  803050:	41 5f                	pop    %r15
  803052:	5d                   	pop    %rbp
  803053:	c3                   	ret

0000000000803054 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803054:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803058:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80305d:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803064:	00 00 00 
  803067:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80306b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80306f:	48 c1 e2 04          	shl    $0x4,%rdx
  803073:	48 01 ca             	add    %rcx,%rdx
  803076:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80307c:	39 fa                	cmp    %edi,%edx
  80307e:	74 12                	je     803092 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803080:	48 83 c0 01          	add    $0x1,%rax
  803084:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80308a:	75 db                	jne    803067 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803091:	c3                   	ret
            return envs[i].env_id;
  803092:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803096:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80309a:	48 c1 e2 04          	shl    $0x4,%rdx
  80309e:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8030a5:	00 00 00 
  8030a8:	48 01 d0             	add    %rdx,%rax
  8030ab:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030b1:	c3                   	ret

00000000008030b2 <__text_end>:
  8030b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030b9:	00 00 00 
  8030bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030c3:	00 00 00 
  8030c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030cd:	00 00 00 
  8030d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030d7:	00 00 00 
  8030da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030e1:	00 00 00 
  8030e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030eb:	00 00 00 
  8030ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030f5:	00 00 00 
  8030f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030ff:	00 00 00 
  803102:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803109:	00 00 00 
  80310c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803113:	00 00 00 
  803116:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80311d:	00 00 00 
  803120:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803127:	00 00 00 
  80312a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803131:	00 00 00 
  803134:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80313b:	00 00 00 
  80313e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803145:	00 00 00 
  803148:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80314f:	00 00 00 
  803152:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803159:	00 00 00 
  80315c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803163:	00 00 00 
  803166:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80316d:	00 00 00 
  803170:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803177:	00 00 00 
  80317a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803181:	00 00 00 
  803184:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80318b:	00 00 00 
  80318e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803195:	00 00 00 
  803198:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80319f:	00 00 00 
  8031a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031a9:	00 00 00 
  8031ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031b3:	00 00 00 
  8031b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031bd:	00 00 00 
  8031c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031c7:	00 00 00 
  8031ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031d1:	00 00 00 
  8031d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031db:	00 00 00 
  8031de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031e5:	00 00 00 
  8031e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031ef:	00 00 00 
  8031f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031f9:	00 00 00 
  8031fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803203:	00 00 00 
  803206:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80320d:	00 00 00 
  803210:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803217:	00 00 00 
  80321a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803221:	00 00 00 
  803224:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80322b:	00 00 00 
  80322e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803235:	00 00 00 
  803238:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80323f:	00 00 00 
  803242:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803249:	00 00 00 
  80324c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803253:	00 00 00 
  803256:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80325d:	00 00 00 
  803260:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803267:	00 00 00 
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
