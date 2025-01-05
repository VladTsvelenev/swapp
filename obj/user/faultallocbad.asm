
obj/user/faultallocbad:     file format elf64-x86-64


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
  80001e:	e8 f2 00 00 00       	call   800115 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <handler>:
 * doesn't work because we sys_cputs instead of cprintf (exercise: why?) */

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
  800047:	48 ba 4a 03 80 00 00 	movabs $0x80034a,%rdx
  80004e:	00 00 00 
  800051:	ff d2                	call   *%rdx
    if ((r = sys_alloc_region(0, ROUNDDOWN(addr, PAGE_SIZE),
  800053:	48 89 de             	mov    %rbx,%rsi
  800056:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  80005d:	b9 06 00 00 00       	mov    $0x6,%ecx
  800062:	ba 00 10 00 00       	mov    $0x1000,%edx
  800067:	bf 00 00 00 00       	mov    $0x0,%edi
  80006c:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
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
  800096:	49 b8 0d 0c 80 00 00 	movabs $0x800c0d,%r8
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
  8000be:	be 0e 00 00 00       	mov    $0xe,%esi
  8000c3:	48 bf 0b 40 80 00 00 	movabs $0x80400b,%rdi
  8000ca:	00 00 00 
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  8000d9:	00 00 00 
  8000dc:	41 ff d1             	call   *%r9

00000000008000df <umain>:

void
umain(int argc, char **argv) {
  8000df:	f3 0f 1e fa          	endbr64
  8000e3:	55                   	push   %rbp
  8000e4:	48 89 e5             	mov    %rsp,%rbp
    add_pgfault_handler(handler);
  8000e7:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  8000ee:	00 00 00 
  8000f1:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	call   *%rax
    sys_cputs((char *)0xDEADBEEF, 4);
  8000fd:	be 04 00 00 00       	mov    $0x4,%esi
  800102:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800107:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  80010e:	00 00 00 
  800111:	ff d0                	call   *%rax
}
  800113:	5d                   	pop    %rbp
  800114:	c3                   	ret

0000000000800115 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800115:	f3 0f 1e fa          	endbr64
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	41 56                	push   %r14
  80011f:	41 55                	push   %r13
  800121:	41 54                	push   %r12
  800123:	53                   	push   %rbx
  800124:	41 89 fd             	mov    %edi,%r13d
  800127:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80012a:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800131:	00 00 00 
  800134:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80013b:	00 00 00 
  80013e:	48 39 c2             	cmp    %rax,%rdx
  800141:	73 17                	jae    80015a <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800143:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800146:	49 89 c4             	mov    %rax,%r12
  800149:	48 83 c3 08          	add    $0x8,%rbx
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	ff 53 f8             	call   *-0x8(%rbx)
  800155:	4c 39 e3             	cmp    %r12,%rbx
  800158:	72 ef                	jb     800149 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80015a:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  800161:	00 00 00 
  800164:	ff d0                	call   *%rax
  800166:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80016f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800173:	48 c1 e0 04          	shl    $0x4,%rax
  800177:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80017e:	00 00 00 
  800181:	48 01 d0             	add    %rdx,%rax
  800184:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  80018b:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80018e:	45 85 ed             	test   %r13d,%r13d
  800191:	7e 0d                	jle    8001a0 <libmain+0x8b>
  800193:	49 8b 06             	mov    (%r14),%rax
  800196:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80019d:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001a0:	4c 89 f6             	mov    %r14,%rsi
  8001a3:	44 89 ef             	mov    %r13d,%edi
  8001a6:	48 b8 df 00 80 00 00 	movabs $0x8000df,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001b2:	48 b8 c7 01 80 00 00 	movabs $0x8001c7,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	call   *%rax
#endif
}
  8001be:	5b                   	pop    %rbx
  8001bf:	41 5c                	pop    %r12
  8001c1:	41 5d                	pop    %r13
  8001c3:	41 5e                	pop    %r14
  8001c5:	5d                   	pop    %rbp
  8001c6:	c3                   	ret

00000000008001c7 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001c7:	f3 0f 1e fa          	endbr64
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001cf:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  8001d6:	00 00 00 
  8001d9:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001db:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e0:	48 b8 59 11 80 00 00 	movabs $0x801159,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	call   *%rax
}
  8001ec:	5d                   	pop    %rbp
  8001ed:	c3                   	ret

00000000008001ee <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8001ee:	f3 0f 1e fa          	endbr64
  8001f2:	55                   	push   %rbp
  8001f3:	48 89 e5             	mov    %rsp,%rbp
  8001f6:	41 56                	push   %r14
  8001f8:	41 55                	push   %r13
  8001fa:	41 54                	push   %r12
  8001fc:	53                   	push   %rbx
  8001fd:	48 83 ec 50          	sub    $0x50,%rsp
  800201:	49 89 fc             	mov    %rdi,%r12
  800204:	41 89 f5             	mov    %esi,%r13d
  800207:	48 89 d3             	mov    %rdx,%rbx
  80020a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80020e:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800212:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800216:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80021d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800221:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800225:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800229:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80022d:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800234:	00 00 00 
  800237:	4c 8b 30             	mov    (%rax),%r14
  80023a:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  800241:	00 00 00 
  800244:	ff d0                	call   *%rax
  800246:	89 c6                	mov    %eax,%esi
  800248:	45 89 e8             	mov    %r13d,%r8d
  80024b:	4c 89 e1             	mov    %r12,%rcx
  80024e:	4c 89 f2             	mov    %r14,%rdx
  800251:	48 bf 10 43 80 00 00 	movabs $0x804310,%rdi
  800258:	00 00 00 
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	49 bc 4a 03 80 00 00 	movabs $0x80034a,%r12
  800267:	00 00 00 
  80026a:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80026d:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800271:	48 89 df             	mov    %rbx,%rdi
  800274:	48 b8 e2 02 80 00 00 	movabs $0x8002e2,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	call   *%rax
    cprintf("\n");
  800280:	48 bf 36 42 80 00 00 	movabs $0x804236,%rdi
  800287:	00 00 00 
  80028a:	b8 00 00 00 00       	mov    $0x0,%eax
  80028f:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800292:	cc                   	int3
  800293:	eb fd                	jmp    800292 <_panic+0xa4>

0000000000800295 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800295:	f3 0f 1e fa          	endbr64
  800299:	55                   	push   %rbp
  80029a:	48 89 e5             	mov    %rsp,%rbp
  80029d:	53                   	push   %rbx
  80029e:	48 83 ec 08          	sub    $0x8,%rsp
  8002a2:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002a5:	8b 06                	mov    (%rsi),%eax
  8002a7:	8d 50 01             	lea    0x1(%rax),%edx
  8002aa:	89 16                	mov    %edx,(%rsi)
  8002ac:	48 98                	cltq
  8002ae:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002b3:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002b9:	74 0a                	je     8002c5 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8002bb:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8002bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002c3:	c9                   	leave
  8002c4:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8002c5:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002c9:	be ff 00 00 00       	mov    $0xff,%esi
  8002ce:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	call   *%rax
        state->offset = 0;
  8002da:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8002e0:	eb d9                	jmp    8002bb <putch+0x26>

00000000008002e2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8002e2:	f3 0f 1e fa          	endbr64
  8002e6:	55                   	push   %rbp
  8002e7:	48 89 e5             	mov    %rsp,%rbp
  8002ea:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002f1:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8002f4:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002fb:	b9 21 00 00 00       	mov    $0x21,%ecx
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800308:	48 89 f1             	mov    %rsi,%rcx
  80030b:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800312:	48 bf 95 02 80 00 00 	movabs $0x800295,%rdi
  800319:	00 00 00 
  80031c:	48 b8 aa 04 80 00 00 	movabs $0x8004aa,%rax
  800323:	00 00 00 
  800326:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800328:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80032f:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800336:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  80033d:	00 00 00 
  800340:	ff d0                	call   *%rax

    return state.count;
}
  800342:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800348:	c9                   	leave
  800349:	c3                   	ret

000000000080034a <cprintf>:

int
cprintf(const char *fmt, ...) {
  80034a:	f3 0f 1e fa          	endbr64
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	48 83 ec 50          	sub    $0x50,%rsp
  800356:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80035a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80035e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800362:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800366:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80036a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800371:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800375:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800379:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80037d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800381:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800385:	48 b8 e2 02 80 00 00 	movabs $0x8002e2,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800391:	c9                   	leave
  800392:	c3                   	ret

0000000000800393 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800393:	f3 0f 1e fa          	endbr64
  800397:	55                   	push   %rbp
  800398:	48 89 e5             	mov    %rsp,%rbp
  80039b:	41 57                	push   %r15
  80039d:	41 56                	push   %r14
  80039f:	41 55                	push   %r13
  8003a1:	41 54                	push   %r12
  8003a3:	53                   	push   %rbx
  8003a4:	48 83 ec 18          	sub    $0x18,%rsp
  8003a8:	49 89 fc             	mov    %rdi,%r12
  8003ab:	49 89 f5             	mov    %rsi,%r13
  8003ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003b2:	8b 45 10             	mov    0x10(%rbp),%eax
  8003b5:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003b8:	41 89 cf             	mov    %ecx,%r15d
  8003bb:	4c 39 fa             	cmp    %r15,%rdx
  8003be:	73 5b                	jae    80041b <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8003c0:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8003c4:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003c8:	85 db                	test   %ebx,%ebx
  8003ca:	7e 0e                	jle    8003da <print_num+0x47>
            putch(padc, put_arg);
  8003cc:	4c 89 ee             	mov    %r13,%rsi
  8003cf:	44 89 f7             	mov    %r14d,%edi
  8003d2:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003d5:	83 eb 01             	sub    $0x1,%ebx
  8003d8:	75 f2                	jne    8003cc <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8003da:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8003de:	48 b9 3b 40 80 00 00 	movabs $0x80403b,%rcx
  8003e5:	00 00 00 
  8003e8:	48 b8 2a 40 80 00 00 	movabs $0x80402a,%rax
  8003ef:	00 00 00 
  8003f2:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ff:	49 f7 f7             	div    %r15
  800402:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800406:	4c 89 ee             	mov    %r13,%rsi
  800409:	41 ff d4             	call   *%r12
}
  80040c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800410:	5b                   	pop    %rbx
  800411:	41 5c                	pop    %r12
  800413:	41 5d                	pop    %r13
  800415:	41 5e                	pop    %r14
  800417:	41 5f                	pop    %r15
  800419:	5d                   	pop    %rbp
  80041a:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80041b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	49 f7 f7             	div    %r15
  800427:	48 83 ec 08          	sub    $0x8,%rsp
  80042b:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80042f:	52                   	push   %rdx
  800430:	45 0f be c9          	movsbl %r9b,%r9d
  800434:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800438:	48 89 c2             	mov    %rax,%rdx
  80043b:	48 b8 93 03 80 00 00 	movabs $0x800393,%rax
  800442:	00 00 00 
  800445:	ff d0                	call   *%rax
  800447:	48 83 c4 10          	add    $0x10,%rsp
  80044b:	eb 8d                	jmp    8003da <print_num+0x47>

000000000080044d <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80044d:	f3 0f 1e fa          	endbr64
    state->count++;
  800451:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800455:	48 8b 06             	mov    (%rsi),%rax
  800458:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80045c:	73 0a                	jae    800468 <sprintputch+0x1b>
        *state->start++ = ch;
  80045e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800462:	48 89 16             	mov    %rdx,(%rsi)
  800465:	40 88 38             	mov    %dil,(%rax)
    }
}
  800468:	c3                   	ret

0000000000800469 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800469:	f3 0f 1e fa          	endbr64
  80046d:	55                   	push   %rbp
  80046e:	48 89 e5             	mov    %rsp,%rbp
  800471:	48 83 ec 50          	sub    $0x50,%rsp
  800475:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800479:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80047d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800481:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800488:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80048c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800490:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800494:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800498:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80049c:	48 b8 aa 04 80 00 00 	movabs $0x8004aa,%rax
  8004a3:	00 00 00 
  8004a6:	ff d0                	call   *%rax
}
  8004a8:	c9                   	leave
  8004a9:	c3                   	ret

00000000008004aa <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004aa:	f3 0f 1e fa          	endbr64
  8004ae:	55                   	push   %rbp
  8004af:	48 89 e5             	mov    %rsp,%rbp
  8004b2:	41 57                	push   %r15
  8004b4:	41 56                	push   %r14
  8004b6:	41 55                	push   %r13
  8004b8:	41 54                	push   %r12
  8004ba:	53                   	push   %rbx
  8004bb:	48 83 ec 38          	sub    $0x38,%rsp
  8004bf:	49 89 fe             	mov    %rdi,%r14
  8004c2:	49 89 f5             	mov    %rsi,%r13
  8004c5:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8004c8:	48 8b 01             	mov    (%rcx),%rax
  8004cb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004cf:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d7:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004db:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8004df:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8004e3:	0f b6 3b             	movzbl (%rbx),%edi
  8004e6:	40 80 ff 25          	cmp    $0x25,%dil
  8004ea:	74 18                	je     800504 <vprintfmt+0x5a>
            if (!ch) return;
  8004ec:	40 84 ff             	test   %dil,%dil
  8004ef:	0f 84 b2 06 00 00    	je     800ba7 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8004f5:	40 0f b6 ff          	movzbl %dil,%edi
  8004f9:	4c 89 ee             	mov    %r13,%rsi
  8004fc:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8004ff:	4c 89 e3             	mov    %r12,%rbx
  800502:	eb db                	jmp    8004df <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800504:	be 00 00 00 00       	mov    $0x0,%esi
  800509:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80050d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800512:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800518:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80051f:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800523:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800528:	41 0f b6 04 24       	movzbl (%r12),%eax
  80052d:	88 45 a0             	mov    %al,-0x60(%rbp)
  800530:	83 e8 23             	sub    $0x23,%eax
  800533:	3c 57                	cmp    $0x57,%al
  800535:	0f 87 52 06 00 00    	ja     800b8d <vprintfmt+0x6e3>
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	48 b9 20 44 80 00 00 	movabs $0x804420,%rcx
  800545:	00 00 00 
  800548:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80054c:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80054f:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800553:	eb ce                	jmp    800523 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800555:	49 89 dc             	mov    %rbx,%r12
  800558:	be 01 00 00 00       	mov    $0x1,%esi
  80055d:	eb c4                	jmp    800523 <vprintfmt+0x79>
            padc = ch;
  80055f:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800563:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800566:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800569:	eb b8                	jmp    800523 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80056b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80056e:	83 f8 2f             	cmp    $0x2f,%eax
  800571:	77 24                	ja     800597 <vprintfmt+0xed>
  800573:	89 c1                	mov    %eax,%ecx
  800575:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800579:	83 c0 08             	add    $0x8,%eax
  80057c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80057f:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800582:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800585:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800589:	79 98                	jns    800523 <vprintfmt+0x79>
                width = precision;
  80058b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80058f:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800595:	eb 8c                	jmp    800523 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800597:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80059b:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80059f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005a3:	eb da                	jmp    80057f <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8005a5:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8005aa:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005ae:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8005b4:	3c 39                	cmp    $0x39,%al
  8005b6:	77 1c                	ja     8005d4 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8005b8:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8005bc:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8005c0:	0f b6 c0             	movzbl %al,%eax
  8005c3:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005c8:	0f b6 03             	movzbl (%rbx),%eax
  8005cb:	3c 39                	cmp    $0x39,%al
  8005cd:	76 e9                	jbe    8005b8 <vprintfmt+0x10e>
        process_precision:
  8005cf:	49 89 dc             	mov    %rbx,%r12
  8005d2:	eb b1                	jmp    800585 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8005d4:	49 89 dc             	mov    %rbx,%r12
  8005d7:	eb ac                	jmp    800585 <vprintfmt+0xdb>
            width = MAX(0, width);
  8005d9:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8005dc:	85 c9                	test   %ecx,%ecx
  8005de:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e3:	0f 49 c1             	cmovns %ecx,%eax
  8005e6:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8005e9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005ec:	e9 32 ff ff ff       	jmp    800523 <vprintfmt+0x79>
            lflag++;
  8005f1:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005f4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005f7:	e9 27 ff ff ff       	jmp    800523 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8005fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005ff:	83 f8 2f             	cmp    $0x2f,%eax
  800602:	77 19                	ja     80061d <vprintfmt+0x173>
  800604:	89 c2                	mov    %eax,%edx
  800606:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80060a:	83 c0 08             	add    $0x8,%eax
  80060d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800610:	8b 3a                	mov    (%rdx),%edi
  800612:	4c 89 ee             	mov    %r13,%rsi
  800615:	41 ff d6             	call   *%r14
            break;
  800618:	e9 c2 fe ff ff       	jmp    8004df <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80061d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800621:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800625:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800629:	eb e5                	jmp    800610 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80062b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80062e:	83 f8 2f             	cmp    $0x2f,%eax
  800631:	77 5a                	ja     80068d <vprintfmt+0x1e3>
  800633:	89 c2                	mov    %eax,%edx
  800635:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800639:	83 c0 08             	add    $0x8,%eax
  80063c:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80063f:	8b 02                	mov    (%rdx),%eax
  800641:	89 c1                	mov    %eax,%ecx
  800643:	f7 d9                	neg    %ecx
  800645:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800648:	83 f9 13             	cmp    $0x13,%ecx
  80064b:	7f 4e                	jg     80069b <vprintfmt+0x1f1>
  80064d:	48 63 c1             	movslq %ecx,%rax
  800650:	48 ba e0 46 80 00 00 	movabs $0x8046e0,%rdx
  800657:	00 00 00 
  80065a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80065e:	48 85 c0             	test   %rax,%rax
  800661:	74 38                	je     80069b <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800663:	48 89 c1             	mov    %rax,%rcx
  800666:	48 ba 19 42 80 00 00 	movabs $0x804219,%rdx
  80066d:	00 00 00 
  800670:	4c 89 ee             	mov    %r13,%rsi
  800673:	4c 89 f7             	mov    %r14,%rdi
  800676:	b8 00 00 00 00       	mov    $0x0,%eax
  80067b:	49 b8 69 04 80 00 00 	movabs $0x800469,%r8
  800682:	00 00 00 
  800685:	41 ff d0             	call   *%r8
  800688:	e9 52 fe ff ff       	jmp    8004df <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80068d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800691:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800695:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800699:	eb a4                	jmp    80063f <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80069b:	48 ba 53 40 80 00 00 	movabs $0x804053,%rdx
  8006a2:	00 00 00 
  8006a5:	4c 89 ee             	mov    %r13,%rsi
  8006a8:	4c 89 f7             	mov    %r14,%rdi
  8006ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b0:	49 b8 69 04 80 00 00 	movabs $0x800469,%r8
  8006b7:	00 00 00 
  8006ba:	41 ff d0             	call   *%r8
  8006bd:	e9 1d fe ff ff       	jmp    8004df <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006c5:	83 f8 2f             	cmp    $0x2f,%eax
  8006c8:	77 6c                	ja     800736 <vprintfmt+0x28c>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006d0:	83 c0 08             	add    $0x8,%eax
  8006d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006d6:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8006d9:	48 85 d2             	test   %rdx,%rdx
  8006dc:	48 b8 4c 40 80 00 00 	movabs $0x80404c,%rax
  8006e3:	00 00 00 
  8006e6:	48 0f 45 c2          	cmovne %rdx,%rax
  8006ea:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8006ee:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006f2:	7e 06                	jle    8006fa <vprintfmt+0x250>
  8006f4:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8006f8:	75 4a                	jne    800744 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006fa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8006fe:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800702:	0f b6 00             	movzbl (%rax),%eax
  800705:	84 c0                	test   %al,%al
  800707:	0f 85 9a 00 00 00    	jne    8007a7 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80070d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800710:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800714:	85 c0                	test   %eax,%eax
  800716:	0f 8e c3 fd ff ff    	jle    8004df <vprintfmt+0x35>
  80071c:	4c 89 ee             	mov    %r13,%rsi
  80071f:	bf 20 00 00 00       	mov    $0x20,%edi
  800724:	41 ff d6             	call   *%r14
  800727:	41 83 ec 01          	sub    $0x1,%r12d
  80072b:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80072f:	75 eb                	jne    80071c <vprintfmt+0x272>
  800731:	e9 a9 fd ff ff       	jmp    8004df <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800736:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80073a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80073e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800742:	eb 92                	jmp    8006d6 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800744:	49 63 f7             	movslq %r15d,%rsi
  800747:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80074b:	48 b8 6d 0c 80 00 00 	movabs $0x800c6d,%rax
  800752:	00 00 00 
  800755:	ff d0                	call   *%rax
  800757:	48 89 c2             	mov    %rax,%rdx
  80075a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80075d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80075f:	8d 70 ff             	lea    -0x1(%rax),%esi
  800762:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800765:	85 c0                	test   %eax,%eax
  800767:	7e 91                	jle    8006fa <vprintfmt+0x250>
  800769:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80076e:	4c 89 ee             	mov    %r13,%rsi
  800771:	44 89 e7             	mov    %r12d,%edi
  800774:	41 ff d6             	call   *%r14
  800777:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80077b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80077e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800781:	75 eb                	jne    80076e <vprintfmt+0x2c4>
  800783:	e9 72 ff ff ff       	jmp    8006fa <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800788:	0f b6 f8             	movzbl %al,%edi
  80078b:	4c 89 ee             	mov    %r13,%rsi
  80078e:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800791:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800795:	49 83 c4 01          	add    $0x1,%r12
  800799:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80079f:	84 c0                	test   %al,%al
  8007a1:	0f 84 66 ff ff ff    	je     80070d <vprintfmt+0x263>
  8007a7:	45 85 ff             	test   %r15d,%r15d
  8007aa:	78 0a                	js     8007b6 <vprintfmt+0x30c>
  8007ac:	41 83 ef 01          	sub    $0x1,%r15d
  8007b0:	0f 88 57 ff ff ff    	js     80070d <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007b6:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8007ba:	74 cc                	je     800788 <vprintfmt+0x2de>
  8007bc:	8d 50 e0             	lea    -0x20(%rax),%edx
  8007bf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8007c4:	80 fa 5e             	cmp    $0x5e,%dl
  8007c7:	77 c2                	ja     80078b <vprintfmt+0x2e1>
  8007c9:	eb bd                	jmp    800788 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8007cb:	40 84 f6             	test   %sil,%sil
  8007ce:	75 26                	jne    8007f6 <vprintfmt+0x34c>
    switch (lflag) {
  8007d0:	85 d2                	test   %edx,%edx
  8007d2:	74 59                	je     80082d <vprintfmt+0x383>
  8007d4:	83 fa 01             	cmp    $0x1,%edx
  8007d7:	74 7b                	je     800854 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8007d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dc:	83 f8 2f             	cmp    $0x2f,%eax
  8007df:	0f 87 96 00 00 00    	ja     80087b <vprintfmt+0x3d1>
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007eb:	83 c0 08             	add    $0x8,%eax
  8007ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f1:	4c 8b 22             	mov    (%rdx),%r12
  8007f4:	eb 17                	jmp    80080d <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8007f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f9:	83 f8 2f             	cmp    $0x2f,%eax
  8007fc:	77 21                	ja     80081f <vprintfmt+0x375>
  8007fe:	89 c2                	mov    %eax,%edx
  800800:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800804:	83 c0 08             	add    $0x8,%eax
  800807:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80080a:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80080d:	4d 85 e4             	test   %r12,%r12
  800810:	78 7a                	js     80088c <vprintfmt+0x3e2>
            num = i;
  800812:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800815:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80081a:	e9 50 02 00 00       	jmp    800a6f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80081f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800823:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800827:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80082b:	eb dd                	jmp    80080a <vprintfmt+0x360>
        return va_arg(*ap, int);
  80082d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800830:	83 f8 2f             	cmp    $0x2f,%eax
  800833:	77 11                	ja     800846 <vprintfmt+0x39c>
  800835:	89 c2                	mov    %eax,%edx
  800837:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80083b:	83 c0 08             	add    $0x8,%eax
  80083e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800841:	4c 63 22             	movslq (%rdx),%r12
  800844:	eb c7                	jmp    80080d <vprintfmt+0x363>
  800846:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80084a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80084e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800852:	eb ed                	jmp    800841 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800854:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800857:	83 f8 2f             	cmp    $0x2f,%eax
  80085a:	77 11                	ja     80086d <vprintfmt+0x3c3>
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800862:	83 c0 08             	add    $0x8,%eax
  800865:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800868:	4c 8b 22             	mov    (%rdx),%r12
  80086b:	eb a0                	jmp    80080d <vprintfmt+0x363>
  80086d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800871:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800875:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800879:	eb ed                	jmp    800868 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80087b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800883:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800887:	e9 65 ff ff ff       	jmp    8007f1 <vprintfmt+0x347>
                putch('-', put_arg);
  80088c:	4c 89 ee             	mov    %r13,%rsi
  80088f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800894:	41 ff d6             	call   *%r14
                i = -i;
  800897:	49 f7 dc             	neg    %r12
  80089a:	e9 73 ff ff ff       	jmp    800812 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80089f:	40 84 f6             	test   %sil,%sil
  8008a2:	75 32                	jne    8008d6 <vprintfmt+0x42c>
    switch (lflag) {
  8008a4:	85 d2                	test   %edx,%edx
  8008a6:	74 5d                	je     800905 <vprintfmt+0x45b>
  8008a8:	83 fa 01             	cmp    $0x1,%edx
  8008ab:	0f 84 82 00 00 00    	je     800933 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8008b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b4:	83 f8 2f             	cmp    $0x2f,%eax
  8008b7:	0f 87 a5 00 00 00    	ja     800962 <vprintfmt+0x4b8>
  8008bd:	89 c2                	mov    %eax,%edx
  8008bf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c3:	83 c0 08             	add    $0x8,%eax
  8008c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8008d1:	e9 99 01 00 00       	jmp    800a6f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008d6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d9:	83 f8 2f             	cmp    $0x2f,%eax
  8008dc:	77 19                	ja     8008f7 <vprintfmt+0x44d>
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008e4:	83 c0 08             	add    $0x8,%eax
  8008e7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ea:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008f2:	e9 78 01 00 00       	jmp    800a6f <vprintfmt+0x5c5>
  8008f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800903:	eb e5                	jmp    8008ea <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800905:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800908:	83 f8 2f             	cmp    $0x2f,%eax
  80090b:	77 18                	ja     800925 <vprintfmt+0x47b>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800913:	83 c0 08             	add    $0x8,%eax
  800916:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800919:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80091b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800920:	e9 4a 01 00 00       	jmp    800a6f <vprintfmt+0x5c5>
  800925:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800929:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80092d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800931:	eb e6                	jmp    800919 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800933:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800936:	83 f8 2f             	cmp    $0x2f,%eax
  800939:	77 19                	ja     800954 <vprintfmt+0x4aa>
  80093b:	89 c2                	mov    %eax,%edx
  80093d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800941:	83 c0 08             	add    $0x8,%eax
  800944:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800947:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80094a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80094f:	e9 1b 01 00 00       	jmp    800a6f <vprintfmt+0x5c5>
  800954:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800958:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80095c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800960:	eb e5                	jmp    800947 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800962:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800966:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80096a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80096e:	e9 56 ff ff ff       	jmp    8008c9 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800973:	40 84 f6             	test   %sil,%sil
  800976:	75 2e                	jne    8009a6 <vprintfmt+0x4fc>
    switch (lflag) {
  800978:	85 d2                	test   %edx,%edx
  80097a:	74 59                	je     8009d5 <vprintfmt+0x52b>
  80097c:	83 fa 01             	cmp    $0x1,%edx
  80097f:	74 7f                	je     800a00 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800981:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800984:	83 f8 2f             	cmp    $0x2f,%eax
  800987:	0f 87 9f 00 00 00    	ja     800a2c <vprintfmt+0x582>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800993:	83 c0 08             	add    $0x8,%eax
  800996:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800999:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80099c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009a1:	e9 c9 00 00 00       	jmp    800a6f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a9:	83 f8 2f             	cmp    $0x2f,%eax
  8009ac:	77 19                	ja     8009c7 <vprintfmt+0x51d>
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b4:	83 c0 08             	add    $0x8,%eax
  8009b7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ba:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009bd:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009c2:	e9 a8 00 00 00       	jmp    800a6f <vprintfmt+0x5c5>
  8009c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d3:	eb e5                	jmp    8009ba <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8009d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d8:	83 f8 2f             	cmp    $0x2f,%eax
  8009db:	77 15                	ja     8009f2 <vprintfmt+0x548>
  8009dd:	89 c2                	mov    %eax,%edx
  8009df:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009e3:	83 c0 08             	add    $0x8,%eax
  8009e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e9:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8009eb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8009f0:	eb 7d                	jmp    800a6f <vprintfmt+0x5c5>
  8009f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009fe:	eb e9                	jmp    8009e9 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a03:	83 f8 2f             	cmp    $0x2f,%eax
  800a06:	77 16                	ja     800a1e <vprintfmt+0x574>
  800a08:	89 c2                	mov    %eax,%edx
  800a0a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a0e:	83 c0 08             	add    $0x8,%eax
  800a11:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a14:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a17:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a1c:	eb 51                	jmp    800a6f <vprintfmt+0x5c5>
  800a1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a22:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a26:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a2a:	eb e8                	jmp    800a14 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800a2c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a30:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a38:	e9 5c ff ff ff       	jmp    800999 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800a3d:	4c 89 ee             	mov    %r13,%rsi
  800a40:	bf 30 00 00 00       	mov    $0x30,%edi
  800a45:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800a48:	4c 89 ee             	mov    %r13,%rsi
  800a4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800a50:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a56:	83 f8 2f             	cmp    $0x2f,%eax
  800a59:	77 47                	ja     800aa2 <vprintfmt+0x5f8>
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a61:	83 c0 08             	add    $0x8,%eax
  800a64:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a67:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a6a:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a6f:	48 83 ec 08          	sub    $0x8,%rsp
  800a73:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800a77:	0f 94 c0             	sete   %al
  800a7a:	0f b6 c0             	movzbl %al,%eax
  800a7d:	50                   	push   %rax
  800a7e:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800a83:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a87:	4c 89 ee             	mov    %r13,%rsi
  800a8a:	4c 89 f7             	mov    %r14,%rdi
  800a8d:	48 b8 93 03 80 00 00 	movabs $0x800393,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	call   *%rax
            break;
  800a99:	48 83 c4 10          	add    $0x10,%rsp
  800a9d:	e9 3d fa ff ff       	jmp    8004df <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800aa2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aaa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aae:	eb b7                	jmp    800a67 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800ab0:	40 84 f6             	test   %sil,%sil
  800ab3:	75 2b                	jne    800ae0 <vprintfmt+0x636>
    switch (lflag) {
  800ab5:	85 d2                	test   %edx,%edx
  800ab7:	74 56                	je     800b0f <vprintfmt+0x665>
  800ab9:	83 fa 01             	cmp    $0x1,%edx
  800abc:	74 7f                	je     800b3d <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800abe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac1:	83 f8 2f             	cmp    $0x2f,%eax
  800ac4:	0f 87 a2 00 00 00    	ja     800b6c <vprintfmt+0x6c2>
  800aca:	89 c2                	mov    %eax,%edx
  800acc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ad0:	83 c0 08             	add    $0x8,%eax
  800ad3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ad9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800ade:	eb 8f                	jmp    800a6f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	83 f8 2f             	cmp    $0x2f,%eax
  800ae6:	77 19                	ja     800b01 <vprintfmt+0x657>
  800ae8:	89 c2                	mov    %eax,%edx
  800aea:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aee:	83 c0 08             	add    $0x8,%eax
  800af1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800af7:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800afc:	e9 6e ff ff ff       	jmp    800a6f <vprintfmt+0x5c5>
  800b01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b05:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b09:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b0d:	eb e5                	jmp    800af4 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800b0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b12:	83 f8 2f             	cmp    $0x2f,%eax
  800b15:	77 18                	ja     800b2f <vprintfmt+0x685>
  800b17:	89 c2                	mov    %eax,%edx
  800b19:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b1d:	83 c0 08             	add    $0x8,%eax
  800b20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b23:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800b25:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b2a:	e9 40 ff ff ff       	jmp    800a6f <vprintfmt+0x5c5>
  800b2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b33:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b3b:	eb e6                	jmp    800b23 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800b3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b40:	83 f8 2f             	cmp    $0x2f,%eax
  800b43:	77 19                	ja     800b5e <vprintfmt+0x6b4>
  800b45:	89 c2                	mov    %eax,%edx
  800b47:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b4b:	83 c0 08             	add    $0x8,%eax
  800b4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b51:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b54:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b59:	e9 11 ff ff ff       	jmp    800a6f <vprintfmt+0x5c5>
  800b5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b62:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b66:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b6a:	eb e5                	jmp    800b51 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800b6c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b70:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b74:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b78:	e9 59 ff ff ff       	jmp    800ad6 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800b7d:	4c 89 ee             	mov    %r13,%rsi
  800b80:	bf 25 00 00 00       	mov    $0x25,%edi
  800b85:	41 ff d6             	call   *%r14
            break;
  800b88:	e9 52 f9 ff ff       	jmp    8004df <vprintfmt+0x35>
            putch('%', put_arg);
  800b8d:	4c 89 ee             	mov    %r13,%rsi
  800b90:	bf 25 00 00 00       	mov    $0x25,%edi
  800b95:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b98:	48 83 eb 01          	sub    $0x1,%rbx
  800b9c:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800ba0:	75 f6                	jne    800b98 <vprintfmt+0x6ee>
  800ba2:	e9 38 f9 ff ff       	jmp    8004df <vprintfmt+0x35>
}
  800ba7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800bab:	5b                   	pop    %rbx
  800bac:	41 5c                	pop    %r12
  800bae:	41 5d                	pop    %r13
  800bb0:	41 5e                	pop    %r14
  800bb2:	41 5f                	pop    %r15
  800bb4:	5d                   	pop    %rbp
  800bb5:	c3                   	ret

0000000000800bb6 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bb6:	f3 0f 1e fa          	endbr64
  800bba:	55                   	push   %rbp
  800bbb:	48 89 e5             	mov    %rsp,%rbp
  800bbe:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800bc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bc6:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800bcb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800bd6:	48 85 ff             	test   %rdi,%rdi
  800bd9:	74 2b                	je     800c06 <vsnprintf+0x50>
  800bdb:	48 85 f6             	test   %rsi,%rsi
  800bde:	74 26                	je     800c06 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800be0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800be4:	48 bf 4d 04 80 00 00 	movabs $0x80044d,%rdi
  800beb:	00 00 00 
  800bee:	48 b8 aa 04 80 00 00 	movabs $0x8004aa,%rax
  800bf5:	00 00 00 
  800bf8:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800bfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfe:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c01:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c04:	c9                   	leave
  800c05:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800c06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c0b:	eb f7                	jmp    800c04 <vsnprintf+0x4e>

0000000000800c0d <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c0d:	f3 0f 1e fa          	endbr64
  800c11:	55                   	push   %rbp
  800c12:	48 89 e5             	mov    %rsp,%rbp
  800c15:	48 83 ec 50          	sub    $0x50,%rsp
  800c19:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c1d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c21:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c25:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c30:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c34:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c38:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c3c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c40:	48 b8 b6 0b 80 00 00 	movabs $0x800bb6,%rax
  800c47:	00 00 00 
  800c4a:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c4c:	c9                   	leave
  800c4d:	c3                   	ret

0000000000800c4e <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800c4e:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c52:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c55:	74 10                	je     800c67 <strlen+0x19>
    size_t n = 0;
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c5c:	48 83 c0 01          	add    $0x1,%rax
  800c60:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c64:	75 f6                	jne    800c5c <strlen+0xe>
  800c66:	c3                   	ret
    size_t n = 0;
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c6c:	c3                   	ret

0000000000800c6d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800c6d:	f3 0f 1e fa          	endbr64
  800c71:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800c74:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800c79:	48 85 f6             	test   %rsi,%rsi
  800c7c:	74 10                	je     800c8e <strnlen+0x21>
  800c7e:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800c82:	74 0b                	je     800c8f <strnlen+0x22>
  800c84:	48 83 c2 01          	add    $0x1,%rdx
  800c88:	48 39 d0             	cmp    %rdx,%rax
  800c8b:	75 f1                	jne    800c7e <strnlen+0x11>
  800c8d:	c3                   	ret
  800c8e:	c3                   	ret
  800c8f:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c92:	c3                   	ret

0000000000800c93 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c93:	f3 0f 1e fa          	endbr64
  800c97:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800ca3:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800ca6:	48 83 c2 01          	add    $0x1,%rdx
  800caa:	84 c9                	test   %cl,%cl
  800cac:	75 f1                	jne    800c9f <strcpy+0xc>
        ;
    return res;
}
  800cae:	c3                   	ret

0000000000800caf <strcat>:

char *
strcat(char *dst, const char *src) {
  800caf:	f3 0f 1e fa          	endbr64
  800cb3:	55                   	push   %rbp
  800cb4:	48 89 e5             	mov    %rsp,%rbp
  800cb7:	41 54                	push   %r12
  800cb9:	53                   	push   %rbx
  800cba:	48 89 fb             	mov    %rdi,%rbx
  800cbd:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800cc0:	48 b8 4e 0c 80 00 00 	movabs $0x800c4e,%rax
  800cc7:	00 00 00 
  800cca:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ccc:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800cd0:	4c 89 e6             	mov    %r12,%rsi
  800cd3:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	call   *%rax
    return dst;
}
  800cdf:	48 89 d8             	mov    %rbx,%rax
  800ce2:	5b                   	pop    %rbx
  800ce3:	41 5c                	pop    %r12
  800ce5:	5d                   	pop    %rbp
  800ce6:	c3                   	ret

0000000000800ce7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ce7:	f3 0f 1e fa          	endbr64
  800ceb:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800cee:	48 85 d2             	test   %rdx,%rdx
  800cf1:	74 1f                	je     800d12 <strncpy+0x2b>
  800cf3:	48 01 fa             	add    %rdi,%rdx
  800cf6:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800cf9:	48 83 c1 01          	add    $0x1,%rcx
  800cfd:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d01:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d05:	41 80 f8 01          	cmp    $0x1,%r8b
  800d09:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d0d:	48 39 ca             	cmp    %rcx,%rdx
  800d10:	75 e7                	jne    800cf9 <strncpy+0x12>
    }
    return ret;
}
  800d12:	c3                   	ret

0000000000800d13 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800d13:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800d17:	48 89 f8             	mov    %rdi,%rax
  800d1a:	48 85 d2             	test   %rdx,%rdx
  800d1d:	74 24                	je     800d43 <strlcpy+0x30>
        while (--size > 0 && *src)
  800d1f:	48 83 ea 01          	sub    $0x1,%rdx
  800d23:	74 1b                	je     800d40 <strlcpy+0x2d>
  800d25:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d29:	0f b6 16             	movzbl (%rsi),%edx
  800d2c:	84 d2                	test   %dl,%dl
  800d2e:	74 10                	je     800d40 <strlcpy+0x2d>
            *dst++ = *src++;
  800d30:	48 83 c6 01          	add    $0x1,%rsi
  800d34:	48 83 c0 01          	add    $0x1,%rax
  800d38:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d3b:	48 39 c8             	cmp    %rcx,%rax
  800d3e:	75 e9                	jne    800d29 <strlcpy+0x16>
        *dst = '\0';
  800d40:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d43:	48 29 f8             	sub    %rdi,%rax
}
  800d46:	c3                   	ret

0000000000800d47 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800d47:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800d4b:	0f b6 07             	movzbl (%rdi),%eax
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 13                	je     800d65 <strcmp+0x1e>
  800d52:	38 06                	cmp    %al,(%rsi)
  800d54:	75 0f                	jne    800d65 <strcmp+0x1e>
  800d56:	48 83 c7 01          	add    $0x1,%rdi
  800d5a:	48 83 c6 01          	add    $0x1,%rsi
  800d5e:	0f b6 07             	movzbl (%rdi),%eax
  800d61:	84 c0                	test   %al,%al
  800d63:	75 ed                	jne    800d52 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d65:	0f b6 c0             	movzbl %al,%eax
  800d68:	0f b6 16             	movzbl (%rsi),%edx
  800d6b:	29 d0                	sub    %edx,%eax
}
  800d6d:	c3                   	ret

0000000000800d6e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800d6e:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800d72:	48 85 d2             	test   %rdx,%rdx
  800d75:	74 1f                	je     800d96 <strncmp+0x28>
  800d77:	0f b6 07             	movzbl (%rdi),%eax
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 1e                	je     800d9c <strncmp+0x2e>
  800d7e:	3a 06                	cmp    (%rsi),%al
  800d80:	75 1a                	jne    800d9c <strncmp+0x2e>
  800d82:	48 83 c7 01          	add    $0x1,%rdi
  800d86:	48 83 c6 01          	add    $0x1,%rsi
  800d8a:	48 83 ea 01          	sub    $0x1,%rdx
  800d8e:	75 e7                	jne    800d77 <strncmp+0x9>

    if (!n) return 0;
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
  800d95:	c3                   	ret
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9b:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d9c:	0f b6 07             	movzbl (%rdi),%eax
  800d9f:	0f b6 16             	movzbl (%rsi),%edx
  800da2:	29 d0                	sub    %edx,%eax
}
  800da4:	c3                   	ret

0000000000800da5 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800da5:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800da9:	0f b6 17             	movzbl (%rdi),%edx
  800dac:	84 d2                	test   %dl,%dl
  800dae:	74 18                	je     800dc8 <strchr+0x23>
        if (*str == c) {
  800db0:	0f be d2             	movsbl %dl,%edx
  800db3:	39 f2                	cmp    %esi,%edx
  800db5:	74 17                	je     800dce <strchr+0x29>
    for (; *str; str++) {
  800db7:	48 83 c7 01          	add    $0x1,%rdi
  800dbb:	0f b6 17             	movzbl (%rdi),%edx
  800dbe:	84 d2                	test   %dl,%dl
  800dc0:	75 ee                	jne    800db0 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc7:	c3                   	ret
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	c3                   	ret
            return (char *)str;
  800dce:	48 89 f8             	mov    %rdi,%rax
}
  800dd1:	c3                   	ret

0000000000800dd2 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800dd2:	f3 0f 1e fa          	endbr64
  800dd6:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800dd9:	0f b6 17             	movzbl (%rdi),%edx
  800ddc:	84 d2                	test   %dl,%dl
  800dde:	74 13                	je     800df3 <strfind+0x21>
  800de0:	0f be d2             	movsbl %dl,%edx
  800de3:	39 f2                	cmp    %esi,%edx
  800de5:	74 0b                	je     800df2 <strfind+0x20>
  800de7:	48 83 c0 01          	add    $0x1,%rax
  800deb:	0f b6 10             	movzbl (%rax),%edx
  800dee:	84 d2                	test   %dl,%dl
  800df0:	75 ee                	jne    800de0 <strfind+0xe>
        ;
    return (char *)str;
}
  800df2:	c3                   	ret
  800df3:	c3                   	ret

0000000000800df4 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800df4:	f3 0f 1e fa          	endbr64
  800df8:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800dfb:	48 89 f8             	mov    %rdi,%rax
  800dfe:	48 f7 d8             	neg    %rax
  800e01:	83 e0 07             	and    $0x7,%eax
  800e04:	49 89 d1             	mov    %rdx,%r9
  800e07:	49 29 c1             	sub    %rax,%r9
  800e0a:	78 36                	js     800e42 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e0c:	40 0f b6 c6          	movzbl %sil,%eax
  800e10:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800e17:	01 01 01 
  800e1a:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e1e:	40 f6 c7 07          	test   $0x7,%dil
  800e22:	75 38                	jne    800e5c <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e24:	4c 89 c9             	mov    %r9,%rcx
  800e27:	48 c1 f9 03          	sar    $0x3,%rcx
  800e2b:	74 0c                	je     800e39 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e2d:	fc                   	cld
  800e2e:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e31:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800e35:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e39:	4d 85 c9             	test   %r9,%r9
  800e3c:	75 45                	jne    800e83 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e3e:	4c 89 c0             	mov    %r8,%rax
  800e41:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800e42:	48 85 d2             	test   %rdx,%rdx
  800e45:	74 f7                	je     800e3e <memset+0x4a>
  800e47:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e4a:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e4d:	48 83 c0 01          	add    $0x1,%rax
  800e51:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e55:	48 39 c2             	cmp    %rax,%rdx
  800e58:	75 f3                	jne    800e4d <memset+0x59>
  800e5a:	eb e2                	jmp    800e3e <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e5c:	40 f6 c7 01          	test   $0x1,%dil
  800e60:	74 06                	je     800e68 <memset+0x74>
  800e62:	88 07                	mov    %al,(%rdi)
  800e64:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e68:	40 f6 c7 02          	test   $0x2,%dil
  800e6c:	74 07                	je     800e75 <memset+0x81>
  800e6e:	66 89 07             	mov    %ax,(%rdi)
  800e71:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e75:	40 f6 c7 04          	test   $0x4,%dil
  800e79:	74 a9                	je     800e24 <memset+0x30>
  800e7b:	89 07                	mov    %eax,(%rdi)
  800e7d:	48 83 c7 04          	add    $0x4,%rdi
  800e81:	eb a1                	jmp    800e24 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e83:	41 f6 c1 04          	test   $0x4,%r9b
  800e87:	74 1b                	je     800ea4 <memset+0xb0>
  800e89:	89 07                	mov    %eax,(%rdi)
  800e8b:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e8f:	41 f6 c1 02          	test   $0x2,%r9b
  800e93:	74 07                	je     800e9c <memset+0xa8>
  800e95:	66 89 07             	mov    %ax,(%rdi)
  800e98:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e9c:	41 f6 c1 01          	test   $0x1,%r9b
  800ea0:	74 9c                	je     800e3e <memset+0x4a>
  800ea2:	eb 06                	jmp    800eaa <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ea4:	41 f6 c1 02          	test   $0x2,%r9b
  800ea8:	75 eb                	jne    800e95 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800eaa:	88 07                	mov    %al,(%rdi)
  800eac:	eb 90                	jmp    800e3e <memset+0x4a>

0000000000800eae <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800eae:	f3 0f 1e fa          	endbr64
  800eb2:	48 89 f8             	mov    %rdi,%rax
  800eb5:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800eb8:	48 39 fe             	cmp    %rdi,%rsi
  800ebb:	73 3b                	jae    800ef8 <memmove+0x4a>
  800ebd:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800ec1:	48 39 d7             	cmp    %rdx,%rdi
  800ec4:	73 32                	jae    800ef8 <memmove+0x4a>
        s += n;
        d += n;
  800ec6:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800eca:	48 89 d6             	mov    %rdx,%rsi
  800ecd:	48 09 fe             	or     %rdi,%rsi
  800ed0:	48 09 ce             	or     %rcx,%rsi
  800ed3:	40 f6 c6 07          	test   $0x7,%sil
  800ed7:	75 12                	jne    800eeb <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800ed9:	48 83 ef 08          	sub    $0x8,%rdi
  800edd:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800ee1:	48 c1 e9 03          	shr    $0x3,%rcx
  800ee5:	fd                   	std
  800ee6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800ee9:	fc                   	cld
  800eea:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800eeb:	48 83 ef 01          	sub    $0x1,%rdi
  800eef:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ef3:	fd                   	std
  800ef4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800ef6:	eb f1                	jmp    800ee9 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ef8:	48 89 f2             	mov    %rsi,%rdx
  800efb:	48 09 c2             	or     %rax,%rdx
  800efe:	48 09 ca             	or     %rcx,%rdx
  800f01:	f6 c2 07             	test   $0x7,%dl
  800f04:	75 0c                	jne    800f12 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f06:	48 c1 e9 03          	shr    $0x3,%rcx
  800f0a:	48 89 c7             	mov    %rax,%rdi
  800f0d:	fc                   	cld
  800f0e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f11:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f12:	48 89 c7             	mov    %rax,%rdi
  800f15:	fc                   	cld
  800f16:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f18:	c3                   	ret

0000000000800f19 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f19:	f3 0f 1e fa          	endbr64
  800f1d:	55                   	push   %rbp
  800f1e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f21:	48 b8 ae 0e 80 00 00 	movabs $0x800eae,%rax
  800f28:	00 00 00 
  800f2b:	ff d0                	call   *%rax
}
  800f2d:	5d                   	pop    %rbp
  800f2e:	c3                   	ret

0000000000800f2f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f2f:	f3 0f 1e fa          	endbr64
  800f33:	55                   	push   %rbp
  800f34:	48 89 e5             	mov    %rsp,%rbp
  800f37:	41 57                	push   %r15
  800f39:	41 56                	push   %r14
  800f3b:	41 55                	push   %r13
  800f3d:	41 54                	push   %r12
  800f3f:	53                   	push   %rbx
  800f40:	48 83 ec 08          	sub    $0x8,%rsp
  800f44:	49 89 fe             	mov    %rdi,%r14
  800f47:	49 89 f7             	mov    %rsi,%r15
  800f4a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f4d:	48 89 f7             	mov    %rsi,%rdi
  800f50:	48 b8 4e 0c 80 00 00 	movabs $0x800c4e,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	call   *%rax
  800f5c:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f5f:	48 89 de             	mov    %rbx,%rsi
  800f62:	4c 89 f7             	mov    %r14,%rdi
  800f65:	48 b8 6d 0c 80 00 00 	movabs $0x800c6d,%rax
  800f6c:	00 00 00 
  800f6f:	ff d0                	call   *%rax
  800f71:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f74:	48 39 c3             	cmp    %rax,%rbx
  800f77:	74 36                	je     800faf <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800f79:	48 89 d8             	mov    %rbx,%rax
  800f7c:	4c 29 e8             	sub    %r13,%rax
  800f7f:	49 39 c4             	cmp    %rax,%r12
  800f82:	73 31                	jae    800fb5 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800f84:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f89:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f8d:	4c 89 fe             	mov    %r15,%rsi
  800f90:	48 b8 19 0f 80 00 00 	movabs $0x800f19,%rax
  800f97:	00 00 00 
  800f9a:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f9c:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800fa0:	48 83 c4 08          	add    $0x8,%rsp
  800fa4:	5b                   	pop    %rbx
  800fa5:	41 5c                	pop    %r12
  800fa7:	41 5d                	pop    %r13
  800fa9:	41 5e                	pop    %r14
  800fab:	41 5f                	pop    %r15
  800fad:	5d                   	pop    %rbp
  800fae:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800faf:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800fb3:	eb eb                	jmp    800fa0 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800fb5:	48 83 eb 01          	sub    $0x1,%rbx
  800fb9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fbd:	48 89 da             	mov    %rbx,%rdx
  800fc0:	4c 89 fe             	mov    %r15,%rsi
  800fc3:	48 b8 19 0f 80 00 00 	movabs $0x800f19,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800fcf:	49 01 de             	add    %rbx,%r14
  800fd2:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800fd7:	eb c3                	jmp    800f9c <strlcat+0x6d>

0000000000800fd9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800fd9:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800fdd:	48 85 d2             	test   %rdx,%rdx
  800fe0:	74 2d                	je     80100f <memcmp+0x36>
  800fe2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800fe7:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800feb:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800ff0:	44 38 c1             	cmp    %r8b,%cl
  800ff3:	75 0f                	jne    801004 <memcmp+0x2b>
    while (n-- > 0) {
  800ff5:	48 83 c0 01          	add    $0x1,%rax
  800ff9:	48 39 c2             	cmp    %rax,%rdx
  800ffc:	75 e9                	jne    800fe7 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  801003:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801004:	0f b6 c1             	movzbl %cl,%eax
  801007:	45 0f b6 c0          	movzbl %r8b,%r8d
  80100b:	44 29 c0             	sub    %r8d,%eax
  80100e:	c3                   	ret
    return 0;
  80100f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801014:	c3                   	ret

0000000000801015 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801015:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801019:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80101d:	48 39 c7             	cmp    %rax,%rdi
  801020:	73 0f                	jae    801031 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801022:	40 38 37             	cmp    %sil,(%rdi)
  801025:	74 0e                	je     801035 <memfind+0x20>
    for (; src < end; src++) {
  801027:	48 83 c7 01          	add    $0x1,%rdi
  80102b:	48 39 f8             	cmp    %rdi,%rax
  80102e:	75 f2                	jne    801022 <memfind+0xd>
  801030:	c3                   	ret
  801031:	48 89 f8             	mov    %rdi,%rax
  801034:	c3                   	ret
  801035:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801038:	c3                   	ret

0000000000801039 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801039:	f3 0f 1e fa          	endbr64
  80103d:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801040:	0f b6 37             	movzbl (%rdi),%esi
  801043:	40 80 fe 20          	cmp    $0x20,%sil
  801047:	74 06                	je     80104f <strtol+0x16>
  801049:	40 80 fe 09          	cmp    $0x9,%sil
  80104d:	75 13                	jne    801062 <strtol+0x29>
  80104f:	48 83 c7 01          	add    $0x1,%rdi
  801053:	0f b6 37             	movzbl (%rdi),%esi
  801056:	40 80 fe 20          	cmp    $0x20,%sil
  80105a:	74 f3                	je     80104f <strtol+0x16>
  80105c:	40 80 fe 09          	cmp    $0x9,%sil
  801060:	74 ed                	je     80104f <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801062:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801065:	83 e0 fd             	and    $0xfffffffd,%eax
  801068:	3c 01                	cmp    $0x1,%al
  80106a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80106e:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801074:	75 0f                	jne    801085 <strtol+0x4c>
  801076:	80 3f 30             	cmpb   $0x30,(%rdi)
  801079:	74 14                	je     80108f <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80107b:	85 d2                	test   %edx,%edx
  80107d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801082:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80108a:	4c 63 ca             	movslq %edx,%r9
  80108d:	eb 36                	jmp    8010c5 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80108f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801093:	74 0f                	je     8010a4 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801095:	85 d2                	test   %edx,%edx
  801097:	75 ec                	jne    801085 <strtol+0x4c>
        s++;
  801099:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80109d:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8010a2:	eb e1                	jmp    801085 <strtol+0x4c>
        s += 2;
  8010a4:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010a8:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8010ad:	eb d6                	jmp    801085 <strtol+0x4c>
            dig -= '0';
  8010af:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8010b2:	44 0f b6 c1          	movzbl %cl,%r8d
  8010b6:	41 39 d0             	cmp    %edx,%r8d
  8010b9:	7d 21                	jge    8010dc <strtol+0xa3>
        val = val * base + dig;
  8010bb:	49 0f af c1          	imul   %r9,%rax
  8010bf:	0f b6 c9             	movzbl %cl,%ecx
  8010c2:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8010c5:	48 83 c7 01          	add    $0x1,%rdi
  8010c9:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8010cd:	80 f9 39             	cmp    $0x39,%cl
  8010d0:	76 dd                	jbe    8010af <strtol+0x76>
        else if (dig - 'a' < 27)
  8010d2:	80 f9 7b             	cmp    $0x7b,%cl
  8010d5:	77 05                	ja     8010dc <strtol+0xa3>
            dig -= 'a' - 10;
  8010d7:	83 e9 57             	sub    $0x57,%ecx
  8010da:	eb d6                	jmp    8010b2 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8010dc:	4d 85 d2             	test   %r10,%r10
  8010df:	74 03                	je     8010e4 <strtol+0xab>
  8010e1:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8010e4:	48 89 c2             	mov    %rax,%rdx
  8010e7:	48 f7 da             	neg    %rdx
  8010ea:	40 80 fe 2d          	cmp    $0x2d,%sil
  8010ee:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8010f2:	c3                   	ret

00000000008010f3 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010f3:	f3 0f 1e fa          	endbr64
  8010f7:	55                   	push   %rbp
  8010f8:	48 89 e5             	mov    %rsp,%rbp
  8010fb:	53                   	push   %rbx
  8010fc:	48 89 fa             	mov    %rdi,%rdx
  8010ff:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801102:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801107:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801111:	be 00 00 00 00       	mov    $0x0,%esi
  801116:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80111c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80111e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801122:	c9                   	leave
  801123:	c3                   	ret

0000000000801124 <sys_cgetc>:

int
sys_cgetc(void) {
  801124:	f3 0f 1e fa          	endbr64
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80112d:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80113c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801141:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801146:	be 00 00 00 00       	mov    $0x0,%esi
  80114b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801151:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801153:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801157:	c9                   	leave
  801158:	c3                   	ret

0000000000801159 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801159:	f3 0f 1e fa          	endbr64
  80115d:	55                   	push   %rbp
  80115e:	48 89 e5             	mov    %rsp,%rbp
  801161:	53                   	push   %rbx
  801162:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801166:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801169:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80116e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801173:	bb 00 00 00 00       	mov    $0x0,%ebx
  801178:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80117d:	be 00 00 00 00       	mov    $0x0,%esi
  801182:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801188:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80118a:	48 85 c0             	test   %rax,%rax
  80118d:	7f 06                	jg     801195 <sys_env_destroy+0x3c>
}
  80118f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801193:	c9                   	leave
  801194:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801195:	49 89 c0             	mov    %rax,%r8
  801198:	b9 03 00 00 00       	mov    $0x3,%ecx
  80119d:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8011a4:	00 00 00 
  8011a7:	be 26 00 00 00       	mov    $0x26,%esi
  8011ac:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  8011b3:	00 00 00 
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bb:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  8011c2:	00 00 00 
  8011c5:	41 ff d1             	call   *%r9

00000000008011c8 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8011c8:	f3 0f 1e fa          	endbr64
  8011cc:	55                   	push   %rbp
  8011cd:	48 89 e5             	mov    %rsp,%rbp
  8011d0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011d1:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011db:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ea:	be 00 00 00 00       	mov    $0x0,%esi
  8011ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f5:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011f7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011fb:	c9                   	leave
  8011fc:	c3                   	ret

00000000008011fd <sys_yield>:

void
sys_yield(void) {
  8011fd:	f3 0f 1e fa          	endbr64
  801201:	55                   	push   %rbp
  801202:	48 89 e5             	mov    %rsp,%rbp
  801205:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801206:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80120b:	ba 00 00 00 00       	mov    $0x0,%edx
  801210:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801215:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80121f:	be 00 00 00 00       	mov    $0x0,%esi
  801224:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80122a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80122c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801230:	c9                   	leave
  801231:	c3                   	ret

0000000000801232 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801232:	f3 0f 1e fa          	endbr64
  801236:	55                   	push   %rbp
  801237:	48 89 e5             	mov    %rsp,%rbp
  80123a:	53                   	push   %rbx
  80123b:	48 89 fa             	mov    %rdi,%rdx
  80123e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801241:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801246:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80124d:	00 00 00 
  801250:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801255:	be 00 00 00 00       	mov    $0x0,%esi
  80125a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801260:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801262:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801266:	c9                   	leave
  801267:	c3                   	ret

0000000000801268 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801268:	f3 0f 1e fa          	endbr64
  80126c:	55                   	push   %rbp
  80126d:	48 89 e5             	mov    %rsp,%rbp
  801270:	53                   	push   %rbx
  801271:	49 89 f8             	mov    %rdi,%r8
  801274:	48 89 d3             	mov    %rdx,%rbx
  801277:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80127a:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80127f:	4c 89 c2             	mov    %r8,%rdx
  801282:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801285:	be 00 00 00 00       	mov    $0x0,%esi
  80128a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801290:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801292:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801296:	c9                   	leave
  801297:	c3                   	ret

0000000000801298 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801298:	f3 0f 1e fa          	endbr64
  80129c:	55                   	push   %rbp
  80129d:	48 89 e5             	mov    %rsp,%rbp
  8012a0:	53                   	push   %rbx
  8012a1:	48 83 ec 08          	sub    $0x8,%rsp
  8012a5:	89 f8                	mov    %edi,%eax
  8012a7:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012aa:	48 63 f9             	movslq %ecx,%rdi
  8012ad:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012b0:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012b5:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b8:	be 00 00 00 00       	mov    $0x0,%esi
  8012bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012c5:	48 85 c0             	test   %rax,%rax
  8012c8:	7f 06                	jg     8012d0 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012ca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ce:	c9                   	leave
  8012cf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012d0:	49 89 c0             	mov    %rax,%r8
  8012d3:	b9 04 00 00 00       	mov    $0x4,%ecx
  8012d8:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8012df:	00 00 00 
  8012e2:	be 26 00 00 00       	mov    $0x26,%esi
  8012e7:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  8012ee:	00 00 00 
  8012f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f6:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  8012fd:	00 00 00 
  801300:	41 ff d1             	call   *%r9

0000000000801303 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801303:	f3 0f 1e fa          	endbr64
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	53                   	push   %rbx
  80130c:	48 83 ec 08          	sub    $0x8,%rsp
  801310:	89 f8                	mov    %edi,%eax
  801312:	49 89 f2             	mov    %rsi,%r10
  801315:	48 89 cf             	mov    %rcx,%rdi
  801318:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80131b:	48 63 da             	movslq %edx,%rbx
  80131e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801321:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801326:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801329:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80132c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80132e:	48 85 c0             	test   %rax,%rax
  801331:	7f 06                	jg     801339 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801333:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801337:	c9                   	leave
  801338:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801339:	49 89 c0             	mov    %rax,%r8
  80133c:	b9 05 00 00 00       	mov    $0x5,%ecx
  801341:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801348:	00 00 00 
  80134b:	be 26 00 00 00       	mov    $0x26,%esi
  801350:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  801357:	00 00 00 
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
  80135f:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  801366:	00 00 00 
  801369:	41 ff d1             	call   *%r9

000000000080136c <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80136c:	f3 0f 1e fa          	endbr64
  801370:	55                   	push   %rbp
  801371:	48 89 e5             	mov    %rsp,%rbp
  801374:	53                   	push   %rbx
  801375:	48 83 ec 08          	sub    $0x8,%rsp
  801379:	49 89 f9             	mov    %rdi,%r9
  80137c:	89 f0                	mov    %esi,%eax
  80137e:	48 89 d3             	mov    %rdx,%rbx
  801381:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801384:	49 63 f0             	movslq %r8d,%rsi
  801387:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80138a:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80138f:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801392:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801398:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80139a:	48 85 c0             	test   %rax,%rax
  80139d:	7f 06                	jg     8013a5 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80139f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a3:	c9                   	leave
  8013a4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a5:	49 89 c0             	mov    %rax,%r8
  8013a8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013ad:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8013b4:	00 00 00 
  8013b7:	be 26 00 00 00       	mov    $0x26,%esi
  8013bc:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  8013c3:	00 00 00 
  8013c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cb:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  8013d2:	00 00 00 
  8013d5:	41 ff d1             	call   *%r9

00000000008013d8 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8013d8:	f3 0f 1e fa          	endbr64
  8013dc:	55                   	push   %rbp
  8013dd:	48 89 e5             	mov    %rsp,%rbp
  8013e0:	53                   	push   %rbx
  8013e1:	48 83 ec 08          	sub    $0x8,%rsp
  8013e5:	48 89 f1             	mov    %rsi,%rcx
  8013e8:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8013eb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013ee:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013f3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f8:	be 00 00 00 00       	mov    $0x0,%esi
  8013fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801403:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801405:	48 85 c0             	test   %rax,%rax
  801408:	7f 06                	jg     801410 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80140a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80140e:	c9                   	leave
  80140f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801410:	49 89 c0             	mov    %rax,%r8
  801413:	b9 07 00 00 00       	mov    $0x7,%ecx
  801418:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  80141f:	00 00 00 
  801422:	be 26 00 00 00       	mov    $0x26,%esi
  801427:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  80142e:	00 00 00 
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  80143d:	00 00 00 
  801440:	41 ff d1             	call   *%r9

0000000000801443 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801443:	f3 0f 1e fa          	endbr64
  801447:	55                   	push   %rbp
  801448:	48 89 e5             	mov    %rsp,%rbp
  80144b:	53                   	push   %rbx
  80144c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801450:	48 63 ce             	movslq %esi,%rcx
  801453:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801456:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80145b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801460:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801465:	be 00 00 00 00       	mov    $0x0,%esi
  80146a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801470:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801472:	48 85 c0             	test   %rax,%rax
  801475:	7f 06                	jg     80147d <sys_env_set_status+0x3a>
}
  801477:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80147b:	c9                   	leave
  80147c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80147d:	49 89 c0             	mov    %rax,%r8
  801480:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801485:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  80148c:	00 00 00 
  80148f:	be 26 00 00 00       	mov    $0x26,%esi
  801494:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  80149b:	00 00 00 
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a3:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  8014aa:	00 00 00 
  8014ad:	41 ff d1             	call   *%r9

00000000008014b0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8014b0:	f3 0f 1e fa          	endbr64
  8014b4:	55                   	push   %rbp
  8014b5:	48 89 e5             	mov    %rsp,%rbp
  8014b8:	53                   	push   %rbx
  8014b9:	48 83 ec 08          	sub    $0x8,%rsp
  8014bd:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8014c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014c3:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014cd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014d2:	be 00 00 00 00       	mov    $0x0,%esi
  8014d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014dd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014df:	48 85 c0             	test   %rax,%rax
  8014e2:	7f 06                	jg     8014ea <sys_env_set_trapframe+0x3a>
}
  8014e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e8:	c9                   	leave
  8014e9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014ea:	49 89 c0             	mov    %rax,%r8
  8014ed:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014f2:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  8014f9:	00 00 00 
  8014fc:	be 26 00 00 00       	mov    $0x26,%esi
  801501:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  801508:	00 00 00 
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  801517:	00 00 00 
  80151a:	41 ff d1             	call   *%r9

000000000080151d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80151d:	f3 0f 1e fa          	endbr64
  801521:	55                   	push   %rbp
  801522:	48 89 e5             	mov    %rsp,%rbp
  801525:	53                   	push   %rbx
  801526:	48 83 ec 08          	sub    $0x8,%rsp
  80152a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80152d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801530:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80153f:	be 00 00 00 00       	mov    $0x0,%esi
  801544:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80154c:	48 85 c0             	test   %rax,%rax
  80154f:	7f 06                	jg     801557 <sys_env_set_pgfault_upcall+0x3a>
}
  801551:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801555:	c9                   	leave
  801556:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801557:	49 89 c0             	mov    %rax,%r8
  80155a:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80155f:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801566:	00 00 00 
  801569:	be 26 00 00 00       	mov    $0x26,%esi
  80156e:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  801575:	00 00 00 
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
  80157d:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  801584:	00 00 00 
  801587:	41 ff d1             	call   *%r9

000000000080158a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80158a:	f3 0f 1e fa          	endbr64
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	53                   	push   %rbx
  801593:	89 f8                	mov    %edi,%eax
  801595:	49 89 f1             	mov    %rsi,%r9
  801598:	48 89 d3             	mov    %rdx,%rbx
  80159b:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80159e:	49 63 f0             	movslq %r8d,%rsi
  8015a1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015a4:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015a9:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015b2:	cd 30                	int    $0x30
}
  8015b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015b8:	c9                   	leave
  8015b9:	c3                   	ret

00000000008015ba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8015ba:	f3 0f 1e fa          	endbr64
  8015be:	55                   	push   %rbp
  8015bf:	48 89 e5             	mov    %rsp,%rbp
  8015c2:	53                   	push   %rbx
  8015c3:	48 83 ec 08          	sub    $0x8,%rsp
  8015c7:	48 89 fa             	mov    %rdi,%rdx
  8015ca:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015cd:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015dc:	be 00 00 00 00       	mov    $0x0,%esi
  8015e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e9:	48 85 c0             	test   %rax,%rax
  8015ec:	7f 06                	jg     8015f4 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8015ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f2:	c9                   	leave
  8015f3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f4:	49 89 c0             	mov    %rax,%r8
  8015f7:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8015fc:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801603:	00 00 00 
  801606:	be 26 00 00 00       	mov    $0x26,%esi
  80160b:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  801612:	00 00 00 
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
  80161a:	49 b9 ee 01 80 00 00 	movabs $0x8001ee,%r9
  801621:	00 00 00 
  801624:	41 ff d1             	call   *%r9

0000000000801627 <sys_gettime>:

int
sys_gettime(void) {
  801627:	f3 0f 1e fa          	endbr64
  80162b:	55                   	push   %rbp
  80162c:	48 89 e5             	mov    %rsp,%rbp
  80162f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801630:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801635:	ba 00 00 00 00       	mov    $0x0,%edx
  80163a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80163f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801644:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801649:	be 00 00 00 00       	mov    $0x0,%esi
  80164e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801654:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801656:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80165a:	c9                   	leave
  80165b:	c3                   	ret

000000000080165c <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80165c:	f3 0f 1e fa          	endbr64
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	41 56                	push   %r14
  801666:	41 55                	push   %r13
  801668:	41 54                	push   %r12
  80166a:	53                   	push   %rbx
  80166b:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  80166e:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  801675:	00 00 00 
  801678:	48 83 38 00          	cmpq   $0x0,(%rax)
  80167c:	74 27                	je     8016a5 <_handle_vectored_pagefault+0x49>
  80167e:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  801683:	49 bd 20 60 80 00 00 	movabs $0x806020,%r13
  80168a:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80168d:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  801690:	4c 89 e7             	mov    %r12,%rdi
  801693:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  801698:	84 c0                	test   %al,%al
  80169a:	75 45                	jne    8016e1 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80169c:	48 83 c3 01          	add    $0x1,%rbx
  8016a0:	49 3b 1e             	cmp    (%r14),%rbx
  8016a3:	72 eb                	jb     801690 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8016a5:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8016ac:	00 
  8016ad:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8016b2:	4d 8b 04 24          	mov    (%r12),%r8
  8016b6:	48 ba 78 43 80 00 00 	movabs $0x804378,%rdx
  8016bd:	00 00 00 
  8016c0:	be 1d 00 00 00       	mov    $0x1d,%esi
  8016c5:	48 bf c7 41 80 00 00 	movabs $0x8041c7,%rdi
  8016cc:	00 00 00 
  8016cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d4:	49 ba ee 01 80 00 00 	movabs $0x8001ee,%r10
  8016db:	00 00 00 
  8016de:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8016e1:	5b                   	pop    %rbx
  8016e2:	41 5c                	pop    %r12
  8016e4:	41 5d                	pop    %r13
  8016e6:	41 5e                	pop    %r14
  8016e8:	5d                   	pop    %rbp
  8016e9:	c3                   	ret

00000000008016ea <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8016ea:	f3 0f 1e fa          	endbr64
  8016ee:	55                   	push   %rbp
  8016ef:	48 89 e5             	mov    %rsp,%rbp
  8016f2:	53                   	push   %rbx
  8016f3:	48 83 ec 08          	sub    $0x8,%rsp
  8016f7:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8016fa:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  801701:	00 00 00 
  801704:	80 38 00             	cmpb   $0x0,(%rax)
  801707:	0f 84 84 00 00 00    	je     801791 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80170d:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  801714:	00 00 00 
  801717:	48 8b 10             	mov    (%rax),%rdx
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80171f:	48 b9 20 60 80 00 00 	movabs $0x806020,%rcx
  801726:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  801729:	48 85 d2             	test   %rdx,%rdx
  80172c:	74 19                	je     801747 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  80172e:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  801732:	0f 84 e8 00 00 00    	je     801820 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  801738:	48 83 c0 01          	add    $0x1,%rax
  80173c:	48 39 d0             	cmp    %rdx,%rax
  80173f:	75 ed                	jne    80172e <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  801741:	48 83 fa 08          	cmp    $0x8,%rdx
  801745:	74 1c                	je     801763 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  801747:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80174b:	48 a3 68 60 80 00 00 	movabs %rax,0x806068
  801752:	00 00 00 
  801755:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80175c:	00 00 00 
  80175f:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801763:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  80176a:	00 00 00 
  80176d:	ff d0                	call   *%rax
  80176f:	89 c7                	mov    %eax,%edi
  801771:	48 be ea 18 80 00 00 	movabs $0x8018ea,%rsi
  801778:	00 00 00 
  80177b:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  801782:	00 00 00 
  801785:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801787:	85 c0                	test   %eax,%eax
  801789:	78 68                	js     8017f3 <add_pgfault_handler+0x109>
    return res;
}
  80178b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80178f:	c9                   	leave
  801790:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  801791:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801798:	00 00 00 
  80179b:	ff d0                	call   *%rax
  80179d:	89 c7                	mov    %eax,%edi
  80179f:	b9 06 00 00 00       	mov    $0x6,%ecx
  8017a4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8017a9:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8017b0:	00 00 00 
  8017b3:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  8017bf:	48 ba 68 60 80 00 00 	movabs $0x806068,%rdx
  8017c6:	00 00 00 
  8017c9:	48 8b 02             	mov    (%rdx),%rax
  8017cc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8017d0:	48 89 0a             	mov    %rcx,(%rdx)
  8017d3:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  8017da:	00 00 00 
  8017dd:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8017e1:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8017e8:	00 00 00 
  8017eb:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  8017ee:	e9 70 ff ff ff       	jmp    801763 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8017f3:	89 c1                	mov    %eax,%ecx
  8017f5:	48 ba d5 41 80 00 00 	movabs $0x8041d5,%rdx
  8017fc:	00 00 00 
  8017ff:	be 3d 00 00 00       	mov    $0x3d,%esi
  801804:	48 bf c7 41 80 00 00 	movabs $0x8041c7,%rdi
  80180b:	00 00 00 
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax
  801813:	49 b8 ee 01 80 00 00 	movabs $0x8001ee,%r8
  80181a:	00 00 00 
  80181d:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	e9 61 ff ff ff       	jmp    80178b <add_pgfault_handler+0xa1>

000000000080182a <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  80182a:	f3 0f 1e fa          	endbr64
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  801832:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  801839:	00 00 00 
  80183c:	80 38 00             	cmpb   $0x0,(%rax)
  80183f:	74 33                	je     801874 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  801841:	48 a1 68 60 80 00 00 	movabs 0x806068,%rax
  801848:	00 00 00 
  80184b:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  801850:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  801857:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80185a:	48 85 c0             	test   %rax,%rax
  80185d:	0f 84 85 00 00 00    	je     8018e8 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  801863:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  801867:	74 40                	je     8018a9 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  801869:	48 83 c1 01          	add    $0x1,%rcx
  80186d:	48 39 c1             	cmp    %rax,%rcx
  801870:	75 f1                	jne    801863 <remove_pgfault_handler+0x39>
  801872:	eb 74                	jmp    8018e8 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  801874:	48 b9 ed 41 80 00 00 	movabs $0x8041ed,%rcx
  80187b:	00 00 00 
  80187e:	48 ba 07 42 80 00 00 	movabs $0x804207,%rdx
  801885:	00 00 00 
  801888:	be 43 00 00 00       	mov    $0x43,%esi
  80188d:	48 bf c7 41 80 00 00 	movabs $0x8041c7,%rdi
  801894:	00 00 00 
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	49 b8 ee 01 80 00 00 	movabs $0x8001ee,%r8
  8018a3:	00 00 00 
  8018a6:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8018a9:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8018b0:	00 
  8018b1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018b5:	48 29 ca             	sub    %rcx,%rdx
  8018b8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8018bf:	00 00 00 
  8018c2:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  8018c6:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  8018cb:	48 89 ce             	mov    %rcx,%rsi
  8018ce:	48 b8 ae 0e 80 00 00 	movabs $0x800eae,%rax
  8018d5:	00 00 00 
  8018d8:	ff d0                	call   *%rax
            _pfhandler_off--;
  8018da:	48 b8 68 60 80 00 00 	movabs $0x806068,%rax
  8018e1:	00 00 00 
  8018e4:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  8018e8:	5d                   	pop    %rbp
  8018e9:	c3                   	ret

00000000008018ea <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  8018ea:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  8018ed:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  8018f4:	00 00 00 
    call *%rax
  8018f7:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8018f9:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8018fc:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801903:	00 
    movq UTRAP_RSP(%rsp), %rsp
  801904:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80190b:	00 
    pushq %rbx
  80190c:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  80190d:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  801914:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  801917:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  80191b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80191f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801924:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801929:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80192e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801933:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801938:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80193d:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801942:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801947:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80194c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801951:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801956:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80195b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801960:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801965:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  801969:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80196d:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80196e:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80196f:	c3                   	ret

0000000000801970 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801970:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801974:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80197b:	ff ff ff 
  80197e:	48 01 f8             	add    %rdi,%rax
  801981:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801985:	c3                   	ret

0000000000801986 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801986:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80198a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801991:	ff ff ff 
  801994:	48 01 f8             	add    %rdi,%rax
  801997:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80199b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019a1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8019a5:	c3                   	ret

00000000008019a6 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8019a6:	f3 0f 1e fa          	endbr64
  8019aa:	55                   	push   %rbp
  8019ab:	48 89 e5             	mov    %rsp,%rbp
  8019ae:	41 57                	push   %r15
  8019b0:	41 56                	push   %r14
  8019b2:	41 55                	push   %r13
  8019b4:	41 54                	push   %r12
  8019b6:	53                   	push   %rbx
  8019b7:	48 83 ec 08          	sub    $0x8,%rsp
  8019bb:	49 89 ff             	mov    %rdi,%r15
  8019be:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019c3:	49 bd 05 2b 80 00 00 	movabs $0x802b05,%r13
  8019ca:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019cd:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8019d3:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8019d6:	48 89 df             	mov    %rbx,%rdi
  8019d9:	41 ff d5             	call   *%r13
  8019dc:	83 e0 04             	and    $0x4,%eax
  8019df:	74 17                	je     8019f8 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8019e1:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8019e8:	4c 39 f3             	cmp    %r14,%rbx
  8019eb:	75 e6                	jne    8019d3 <fd_alloc+0x2d>
  8019ed:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8019f3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8019f8:	4d 89 27             	mov    %r12,(%r15)
}
  8019fb:	48 83 c4 08          	add    $0x8,%rsp
  8019ff:	5b                   	pop    %rbx
  801a00:	41 5c                	pop    %r12
  801a02:	41 5d                	pop    %r13
  801a04:	41 5e                	pop    %r14
  801a06:	41 5f                	pop    %r15
  801a08:	5d                   	pop    %rbp
  801a09:	c3                   	ret

0000000000801a0a <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a0a:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a0e:	83 ff 1f             	cmp    $0x1f,%edi
  801a11:	77 39                	ja     801a4c <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a13:	55                   	push   %rbp
  801a14:	48 89 e5             	mov    %rsp,%rbp
  801a17:	41 54                	push   %r12
  801a19:	53                   	push   %rbx
  801a1a:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a1d:	48 63 df             	movslq %edi,%rbx
  801a20:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a27:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a2b:	48 89 df             	mov    %rbx,%rdi
  801a2e:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	call   *%rax
  801a3a:	a8 04                	test   $0x4,%al
  801a3c:	74 14                	je     801a52 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a3e:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a47:	5b                   	pop    %rbx
  801a48:	41 5c                	pop    %r12
  801a4a:	5d                   	pop    %rbp
  801a4b:	c3                   	ret
        return -E_INVAL;
  801a4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a51:	c3                   	ret
        return -E_INVAL;
  801a52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a57:	eb ee                	jmp    801a47 <fd_lookup+0x3d>

0000000000801a59 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a59:	f3 0f 1e fa          	endbr64
  801a5d:	55                   	push   %rbp
  801a5e:	48 89 e5             	mov    %rsp,%rbp
  801a61:	41 54                	push   %r12
  801a63:	53                   	push   %rbx
  801a64:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a67:	48 b8 80 47 80 00 00 	movabs $0x804780,%rax
  801a6e:	00 00 00 
  801a71:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801a78:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a7b:	39 3b                	cmp    %edi,(%rbx)
  801a7d:	74 47                	je     801ac6 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801a7f:	48 83 c0 08          	add    $0x8,%rax
  801a83:	48 8b 18             	mov    (%rax),%rbx
  801a86:	48 85 db             	test   %rbx,%rbx
  801a89:	75 f0                	jne    801a7b <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a8b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a92:	00 00 00 
  801a95:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a9b:	89 fa                	mov    %edi,%edx
  801a9d:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  801aa4:	00 00 00 
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aac:	48 b9 4a 03 80 00 00 	movabs $0x80034a,%rcx
  801ab3:	00 00 00 
  801ab6:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801abd:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801ac1:	5b                   	pop    %rbx
  801ac2:	41 5c                	pop    %r12
  801ac4:	5d                   	pop    %rbp
  801ac5:	c3                   	ret
            return 0;
  801ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  801acb:	eb f0                	jmp    801abd <dev_lookup+0x64>

0000000000801acd <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801acd:	f3 0f 1e fa          	endbr64
  801ad1:	55                   	push   %rbp
  801ad2:	48 89 e5             	mov    %rsp,%rbp
  801ad5:	41 55                	push   %r13
  801ad7:	41 54                	push   %r12
  801ad9:	53                   	push   %rbx
  801ada:	48 83 ec 18          	sub    $0x18,%rsp
  801ade:	48 89 fb             	mov    %rdi,%rbx
  801ae1:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ae4:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801aeb:	ff ff ff 
  801aee:	48 01 df             	add    %rbx,%rdi
  801af1:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801af5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801af9:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	call   *%rax
  801b05:	41 89 c5             	mov    %eax,%r13d
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 06                	js     801b12 <fd_close+0x45>
  801b0c:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801b10:	74 1a                	je     801b2c <fd_close+0x5f>
        return (must_exist ? res : 0);
  801b12:	45 84 e4             	test   %r12b,%r12b
  801b15:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1a:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801b1e:	44 89 e8             	mov    %r13d,%eax
  801b21:	48 83 c4 18          	add    $0x18,%rsp
  801b25:	5b                   	pop    %rbx
  801b26:	41 5c                	pop    %r12
  801b28:	41 5d                	pop    %r13
  801b2a:	5d                   	pop    %rbp
  801b2b:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b2c:	8b 3b                	mov    (%rbx),%edi
  801b2e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b32:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  801b39:	00 00 00 
  801b3c:	ff d0                	call   *%rax
  801b3e:	41 89 c5             	mov    %eax,%r13d
  801b41:	85 c0                	test   %eax,%eax
  801b43:	78 1b                	js     801b60 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b49:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b4d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b53:	48 85 c0             	test   %rax,%rax
  801b56:	74 08                	je     801b60 <fd_close+0x93>
  801b58:	48 89 df             	mov    %rbx,%rdi
  801b5b:	ff d0                	call   *%rax
  801b5d:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b60:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b65:	48 89 de             	mov    %rbx,%rsi
  801b68:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6d:	48 b8 d8 13 80 00 00 	movabs $0x8013d8,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	call   *%rax
    return res;
  801b79:	eb a3                	jmp    801b1e <fd_close+0x51>

0000000000801b7b <close>:

int
close(int fdnum) {
  801b7b:	f3 0f 1e fa          	endbr64
  801b7f:	55                   	push   %rbp
  801b80:	48 89 e5             	mov    %rsp,%rbp
  801b83:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b87:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b8b:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b97:	85 c0                	test   %eax,%eax
  801b99:	78 15                	js     801bb0 <close+0x35>

    return fd_close(fd, 1);
  801b9b:	be 01 00 00 00       	mov    $0x1,%esi
  801ba0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801ba4:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  801bab:	00 00 00 
  801bae:	ff d0                	call   *%rax
}
  801bb0:	c9                   	leave
  801bb1:	c3                   	ret

0000000000801bb2 <close_all>:

void
close_all(void) {
  801bb2:	f3 0f 1e fa          	endbr64
  801bb6:	55                   	push   %rbp
  801bb7:	48 89 e5             	mov    %rsp,%rbp
  801bba:	41 54                	push   %r12
  801bbc:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bc2:	49 bc 7b 1b 80 00 00 	movabs $0x801b7b,%r12
  801bc9:	00 00 00 
  801bcc:	89 df                	mov    %ebx,%edi
  801bce:	41 ff d4             	call   *%r12
  801bd1:	83 c3 01             	add    $0x1,%ebx
  801bd4:	83 fb 20             	cmp    $0x20,%ebx
  801bd7:	75 f3                	jne    801bcc <close_all+0x1a>
}
  801bd9:	5b                   	pop    %rbx
  801bda:	41 5c                	pop    %r12
  801bdc:	5d                   	pop    %rbp
  801bdd:	c3                   	ret

0000000000801bde <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801bde:	f3 0f 1e fa          	endbr64
  801be2:	55                   	push   %rbp
  801be3:	48 89 e5             	mov    %rsp,%rbp
  801be6:	41 57                	push   %r15
  801be8:	41 56                	push   %r14
  801bea:	41 55                	push   %r13
  801bec:	41 54                	push   %r12
  801bee:	53                   	push   %rbx
  801bef:	48 83 ec 18          	sub    $0x18,%rsp
  801bf3:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801bf6:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801bfa:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	call   *%rax
  801c06:	89 c3                	mov    %eax,%ebx
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	0f 88 b8 00 00 00    	js     801cc8 <dup+0xea>
    close(newfdnum);
  801c10:	44 89 e7             	mov    %r12d,%edi
  801c13:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c1f:	4d 63 ec             	movslq %r12d,%r13
  801c22:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c29:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c2d:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801c31:	4c 89 ff             	mov    %r15,%rdi
  801c34:	49 be 86 19 80 00 00 	movabs $0x801986,%r14
  801c3b:	00 00 00 
  801c3e:	41 ff d6             	call   *%r14
  801c41:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c44:	4c 89 ef             	mov    %r13,%rdi
  801c47:	41 ff d6             	call   *%r14
  801c4a:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c4d:	48 89 df             	mov    %rbx,%rdi
  801c50:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  801c57:	00 00 00 
  801c5a:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c5c:	a8 04                	test   $0x4,%al
  801c5e:	74 2b                	je     801c8b <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c60:	41 89 c1             	mov    %eax,%r9d
  801c63:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c69:	4c 89 f1             	mov    %r14,%rcx
  801c6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c71:	48 89 de             	mov    %rbx,%rsi
  801c74:	bf 00 00 00 00       	mov    $0x0,%edi
  801c79:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	call   *%rax
  801c85:	89 c3                	mov    %eax,%ebx
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 4e                	js     801cd9 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c8b:	4c 89 ff             	mov    %r15,%rdi
  801c8e:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	call   *%rax
  801c9a:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c9d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801ca3:	4c 89 e9             	mov    %r13,%rcx
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	4c 89 fe             	mov    %r15,%rsi
  801cae:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb3:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	call   *%rax
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 14                	js     801cd9 <dup+0xfb>

    return newfdnum;
  801cc5:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801cc8:	89 d8                	mov    %ebx,%eax
  801cca:	48 83 c4 18          	add    $0x18,%rsp
  801cce:	5b                   	pop    %rbx
  801ccf:	41 5c                	pop    %r12
  801cd1:	41 5d                	pop    %r13
  801cd3:	41 5e                	pop    %r14
  801cd5:	41 5f                	pop    %r15
  801cd7:	5d                   	pop    %rbp
  801cd8:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801cd9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cde:	4c 89 ee             	mov    %r13,%rsi
  801ce1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce6:	49 bc d8 13 80 00 00 	movabs $0x8013d8,%r12
  801ced:	00 00 00 
  801cf0:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801cf3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cf8:	4c 89 f6             	mov    %r14,%rsi
  801cfb:	bf 00 00 00 00       	mov    $0x0,%edi
  801d00:	41 ff d4             	call   *%r12
    return res;
  801d03:	eb c3                	jmp    801cc8 <dup+0xea>

0000000000801d05 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d05:	f3 0f 1e fa          	endbr64
  801d09:	55                   	push   %rbp
  801d0a:	48 89 e5             	mov    %rsp,%rbp
  801d0d:	41 56                	push   %r14
  801d0f:	41 55                	push   %r13
  801d11:	41 54                	push   %r12
  801d13:	53                   	push   %rbx
  801d14:	48 83 ec 10          	sub    $0x10,%rsp
  801d18:	89 fb                	mov    %edi,%ebx
  801d1a:	49 89 f4             	mov    %rsi,%r12
  801d1d:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d20:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d24:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	call   *%rax
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 4c                	js     801d80 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d34:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d38:	41 8b 3e             	mov    (%r14),%edi
  801d3b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d3f:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	call   *%rax
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 35                	js     801d84 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d4f:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d53:	83 e0 03             	and    $0x3,%eax
  801d56:	83 f8 01             	cmp    $0x1,%eax
  801d59:	74 2d                	je     801d88 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d5f:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d63:	48 85 c0             	test   %rax,%rax
  801d66:	74 56                	je     801dbe <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d68:	4c 89 ea             	mov    %r13,%rdx
  801d6b:	4c 89 e6             	mov    %r12,%rsi
  801d6e:	4c 89 f7             	mov    %r14,%rdi
  801d71:	ff d0                	call   *%rax
}
  801d73:	48 83 c4 10          	add    $0x10,%rsp
  801d77:	5b                   	pop    %rbx
  801d78:	41 5c                	pop    %r12
  801d7a:	41 5d                	pop    %r13
  801d7c:	41 5e                	pop    %r14
  801d7e:	5d                   	pop    %rbp
  801d7f:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d80:	48 98                	cltq
  801d82:	eb ef                	jmp    801d73 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d84:	48 98                	cltq
  801d86:	eb eb                	jmp    801d73 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d88:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d8f:	00 00 00 
  801d92:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d98:	89 da                	mov    %ebx,%edx
  801d9a:	48 bf 1c 42 80 00 00 	movabs $0x80421c,%rdi
  801da1:	00 00 00 
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
  801da9:	48 b9 4a 03 80 00 00 	movabs $0x80034a,%rcx
  801db0:	00 00 00 
  801db3:	ff d1                	call   *%rcx
        return -E_INVAL;
  801db5:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dbc:	eb b5                	jmp    801d73 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801dbe:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dc5:	eb ac                	jmp    801d73 <read+0x6e>

0000000000801dc7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801dc7:	f3 0f 1e fa          	endbr64
  801dcb:	55                   	push   %rbp
  801dcc:	48 89 e5             	mov    %rsp,%rbp
  801dcf:	41 57                	push   %r15
  801dd1:	41 56                	push   %r14
  801dd3:	41 55                	push   %r13
  801dd5:	41 54                	push   %r12
  801dd7:	53                   	push   %rbx
  801dd8:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ddc:	48 85 d2             	test   %rdx,%rdx
  801ddf:	74 54                	je     801e35 <readn+0x6e>
  801de1:	41 89 fd             	mov    %edi,%r13d
  801de4:	49 89 f6             	mov    %rsi,%r14
  801de7:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801dea:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801def:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801df4:	49 bf 05 1d 80 00 00 	movabs $0x801d05,%r15
  801dfb:	00 00 00 
  801dfe:	4c 89 e2             	mov    %r12,%rdx
  801e01:	48 29 f2             	sub    %rsi,%rdx
  801e04:	4c 01 f6             	add    %r14,%rsi
  801e07:	44 89 ef             	mov    %r13d,%edi
  801e0a:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 20                	js     801e31 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801e11:	01 c3                	add    %eax,%ebx
  801e13:	85 c0                	test   %eax,%eax
  801e15:	74 08                	je     801e1f <readn+0x58>
  801e17:	48 63 f3             	movslq %ebx,%rsi
  801e1a:	4c 39 e6             	cmp    %r12,%rsi
  801e1d:	72 df                	jb     801dfe <readn+0x37>
    }
    return res;
  801e1f:	48 63 c3             	movslq %ebx,%rax
}
  801e22:	48 83 c4 08          	add    $0x8,%rsp
  801e26:	5b                   	pop    %rbx
  801e27:	41 5c                	pop    %r12
  801e29:	41 5d                	pop    %r13
  801e2b:	41 5e                	pop    %r14
  801e2d:	41 5f                	pop    %r15
  801e2f:	5d                   	pop    %rbp
  801e30:	c3                   	ret
        if (inc < 0) return inc;
  801e31:	48 98                	cltq
  801e33:	eb ed                	jmp    801e22 <readn+0x5b>
    int inc = 1, res = 0;
  801e35:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e3a:	eb e3                	jmp    801e1f <readn+0x58>

0000000000801e3c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e3c:	f3 0f 1e fa          	endbr64
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	41 56                	push   %r14
  801e46:	41 55                	push   %r13
  801e48:	41 54                	push   %r12
  801e4a:	53                   	push   %rbx
  801e4b:	48 83 ec 10          	sub    $0x10,%rsp
  801e4f:	89 fb                	mov    %edi,%ebx
  801e51:	49 89 f4             	mov    %rsi,%r12
  801e54:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e57:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e5b:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801e62:	00 00 00 
  801e65:	ff d0                	call   *%rax
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 47                	js     801eb2 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e6b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e6f:	41 8b 3e             	mov    (%r14),%edi
  801e72:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e76:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  801e7d:	00 00 00 
  801e80:	ff d0                	call   *%rax
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 30                	js     801eb6 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e86:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e8b:	74 2d                	je     801eba <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e91:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e95:	48 85 c0             	test   %rax,%rax
  801e98:	74 56                	je     801ef0 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801e9a:	4c 89 ea             	mov    %r13,%rdx
  801e9d:	4c 89 e6             	mov    %r12,%rsi
  801ea0:	4c 89 f7             	mov    %r14,%rdi
  801ea3:	ff d0                	call   *%rax
}
  801ea5:	48 83 c4 10          	add    $0x10,%rsp
  801ea9:	5b                   	pop    %rbx
  801eaa:	41 5c                	pop    %r12
  801eac:	41 5d                	pop    %r13
  801eae:	41 5e                	pop    %r14
  801eb0:	5d                   	pop    %rbp
  801eb1:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eb2:	48 98                	cltq
  801eb4:	eb ef                	jmp    801ea5 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eb6:	48 98                	cltq
  801eb8:	eb eb                	jmp    801ea5 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801eba:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801ec1:	00 00 00 
  801ec4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801eca:	89 da                	mov    %ebx,%edx
  801ecc:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  801ed3:	00 00 00 
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	48 b9 4a 03 80 00 00 	movabs $0x80034a,%rcx
  801ee2:	00 00 00 
  801ee5:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ee7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801eee:	eb b5                	jmp    801ea5 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ef0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ef7:	eb ac                	jmp    801ea5 <write+0x69>

0000000000801ef9 <seek>:

int
seek(int fdnum, off_t offset) {
  801ef9:	f3 0f 1e fa          	endbr64
  801efd:	55                   	push   %rbp
  801efe:	48 89 e5             	mov    %rsp,%rbp
  801f01:	53                   	push   %rbx
  801f02:	48 83 ec 18          	sub    $0x18,%rsp
  801f06:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f08:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f0c:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	call   *%rax
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 0c                	js     801f28 <seek+0x2f>

    fd->fd_offset = offset;
  801f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f20:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f28:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f2c:	c9                   	leave
  801f2d:	c3                   	ret

0000000000801f2e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f2e:	f3 0f 1e fa          	endbr64
  801f32:	55                   	push   %rbp
  801f33:	48 89 e5             	mov    %rsp,%rbp
  801f36:	41 55                	push   %r13
  801f38:	41 54                	push   %r12
  801f3a:	53                   	push   %rbx
  801f3b:	48 83 ec 18          	sub    $0x18,%rsp
  801f3f:	89 fb                	mov    %edi,%ebx
  801f41:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f44:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f48:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801f4f:	00 00 00 
  801f52:	ff d0                	call   *%rax
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 38                	js     801f90 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f58:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f5c:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f60:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f64:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  801f6b:	00 00 00 
  801f6e:	ff d0                	call   *%rax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	78 1c                	js     801f90 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f74:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f79:	74 20                	je     801f9b <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f7f:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f83:	48 85 c0             	test   %rax,%rax
  801f86:	74 47                	je     801fcf <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f88:	44 89 e6             	mov    %r12d,%esi
  801f8b:	4c 89 ef             	mov    %r13,%rdi
  801f8e:	ff d0                	call   *%rax
}
  801f90:	48 83 c4 18          	add    $0x18,%rsp
  801f94:	5b                   	pop    %rbx
  801f95:	41 5c                	pop    %r12
  801f97:	41 5d                	pop    %r13
  801f99:	5d                   	pop    %rbp
  801f9a:	c3                   	ret
                thisenv->env_id, fdnum);
  801f9b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801fa2:	00 00 00 
  801fa5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801fab:	89 da                	mov    %ebx,%edx
  801fad:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  801fb4:	00 00 00 
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	48 b9 4a 03 80 00 00 	movabs $0x80034a,%rcx
  801fc3:	00 00 00 
  801fc6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fc8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fcd:	eb c1                	jmp    801f90 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801fcf:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fd4:	eb ba                	jmp    801f90 <ftruncate+0x62>

0000000000801fd6 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801fd6:	f3 0f 1e fa          	endbr64
  801fda:	55                   	push   %rbp
  801fdb:	48 89 e5             	mov    %rsp,%rbp
  801fde:	41 54                	push   %r12
  801fe0:	53                   	push   %rbx
  801fe1:	48 83 ec 10          	sub    $0x10,%rsp
  801fe5:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fe8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fec:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	call   *%rax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	78 4e                	js     80204a <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ffc:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802000:	41 8b 3c 24          	mov    (%r12),%edi
  802004:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802008:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  80200f:	00 00 00 
  802012:	ff d0                	call   *%rax
  802014:	85 c0                	test   %eax,%eax
  802016:	78 32                	js     80204a <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802018:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80201c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802021:	74 30                	je     802053 <fstat+0x7d>

    stat->st_name[0] = 0;
  802023:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802026:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  80202d:	00 00 00 
    stat->st_isdir = 0;
  802030:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802037:	00 00 00 
    stat->st_dev = dev;
  80203a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802041:	48 89 de             	mov    %rbx,%rsi
  802044:	4c 89 e7             	mov    %r12,%rdi
  802047:	ff 50 28             	call   *0x28(%rax)
}
  80204a:	48 83 c4 10          	add    $0x10,%rsp
  80204e:	5b                   	pop    %rbx
  80204f:	41 5c                	pop    %r12
  802051:	5d                   	pop    %rbp
  802052:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802053:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802058:	eb f0                	jmp    80204a <fstat+0x74>

000000000080205a <stat>:

int
stat(const char *path, struct Stat *stat) {
  80205a:	f3 0f 1e fa          	endbr64
  80205e:	55                   	push   %rbp
  80205f:	48 89 e5             	mov    %rsp,%rbp
  802062:	41 54                	push   %r12
  802064:	53                   	push   %rbx
  802065:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802068:	be 00 00 00 00       	mov    $0x0,%esi
  80206d:	48 b8 3b 23 80 00 00 	movabs $0x80233b,%rax
  802074:	00 00 00 
  802077:	ff d0                	call   *%rax
  802079:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 25                	js     8020a4 <stat+0x4a>

    int res = fstat(fd, stat);
  80207f:	4c 89 e6             	mov    %r12,%rsi
  802082:	89 c7                	mov    %eax,%edi
  802084:	48 b8 d6 1f 80 00 00 	movabs $0x801fd6,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	call   *%rax
  802090:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802093:	89 df                	mov    %ebx,%edi
  802095:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  80209c:	00 00 00 
  80209f:	ff d0                	call   *%rax

    return res;
  8020a1:	44 89 e3             	mov    %r12d,%ebx
}
  8020a4:	89 d8                	mov    %ebx,%eax
  8020a6:	5b                   	pop    %rbx
  8020a7:	41 5c                	pop    %r12
  8020a9:	5d                   	pop    %rbp
  8020aa:	c3                   	ret

00000000008020ab <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8020ab:	f3 0f 1e fa          	endbr64
  8020af:	55                   	push   %rbp
  8020b0:	48 89 e5             	mov    %rsp,%rbp
  8020b3:	41 54                	push   %r12
  8020b5:	53                   	push   %rbx
  8020b6:	48 83 ec 10          	sub    $0x10,%rsp
  8020ba:	41 89 fc             	mov    %edi,%r12d
  8020bd:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8020c7:	00 00 00 
  8020ca:	83 38 00             	cmpl   $0x0,(%rax)
  8020cd:	74 6e                	je     80213d <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8020cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8020d4:	48 b8 32 30 80 00 00 	movabs $0x803032,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	call   *%rax
  8020e0:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8020e7:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8020e9:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8020ef:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020f4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8020fb:	00 00 00 
  8020fe:	44 89 e6             	mov    %r12d,%esi
  802101:	89 c7                	mov    %eax,%edi
  802103:	48 b8 70 2f 80 00 00 	movabs $0x802f70,%rax
  80210a:	00 00 00 
  80210d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80210f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802116:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802117:	b9 00 00 00 00       	mov    $0x0,%ecx
  80211c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802120:	48 89 de             	mov    %rbx,%rsi
  802123:	bf 00 00 00 00       	mov    $0x0,%edi
  802128:	48 b8 d7 2e 80 00 00 	movabs $0x802ed7,%rax
  80212f:	00 00 00 
  802132:	ff d0                	call   *%rax
}
  802134:	48 83 c4 10          	add    $0x10,%rsp
  802138:	5b                   	pop    %rbx
  802139:	41 5c                	pop    %r12
  80213b:	5d                   	pop    %rbp
  80213c:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80213d:	bf 03 00 00 00       	mov    $0x3,%edi
  802142:	48 b8 32 30 80 00 00 	movabs $0x803032,%rax
  802149:	00 00 00 
  80214c:	ff d0                	call   *%rax
  80214e:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802155:	00 00 
  802157:	e9 73 ff ff ff       	jmp    8020cf <fsipc+0x24>

000000000080215c <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80215c:	f3 0f 1e fa          	endbr64
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802164:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80216b:	00 00 00 
  80216e:	8b 57 0c             	mov    0xc(%rdi),%edx
  802171:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802173:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802176:	be 00 00 00 00       	mov    $0x0,%esi
  80217b:	bf 02 00 00 00       	mov    $0x2,%edi
  802180:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  802187:	00 00 00 
  80218a:	ff d0                	call   *%rax
}
  80218c:	5d                   	pop    %rbp
  80218d:	c3                   	ret

000000000080218e <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80218e:	f3 0f 1e fa          	endbr64
  802192:	55                   	push   %rbp
  802193:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802196:	8b 47 0c             	mov    0xc(%rdi),%eax
  802199:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021a0:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8021a2:	be 00 00 00 00       	mov    $0x0,%esi
  8021a7:	bf 06 00 00 00       	mov    $0x6,%edi
  8021ac:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	call   *%rax
}
  8021b8:	5d                   	pop    %rbp
  8021b9:	c3                   	ret

00000000008021ba <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8021ba:	f3 0f 1e fa          	endbr64
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	41 54                	push   %r12
  8021c4:	53                   	push   %rbx
  8021c5:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021c8:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021cb:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021d2:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8021d4:	be 00 00 00 00       	mov    $0x0,%esi
  8021d9:	bf 05 00 00 00       	mov    $0x5,%edi
  8021de:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  8021e5:	00 00 00 
  8021e8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 3d                	js     80222b <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021ee:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8021f5:	00 00 00 
  8021f8:	4c 89 e6             	mov    %r12,%rsi
  8021fb:	48 89 df             	mov    %rbx,%rdi
  8021fe:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  802205:	00 00 00 
  802208:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80220a:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802211:	00 
  802212:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802218:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80221f:	00 
  802220:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222b:	5b                   	pop    %rbx
  80222c:	41 5c                	pop    %r12
  80222e:	5d                   	pop    %rbp
  80222f:	c3                   	ret

0000000000802230 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802230:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802234:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80223b:	77 41                	ja     80227e <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802241:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802248:	00 00 00 
  80224b:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80224e:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802250:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802254:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802258:	48 b8 ae 0e 80 00 00 	movabs $0x800eae,%rax
  80225f:	00 00 00 
  802262:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802264:	be 00 00 00 00       	mov    $0x0,%esi
  802269:	bf 04 00 00 00       	mov    $0x4,%edi
  80226e:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  802275:	00 00 00 
  802278:	ff d0                	call   *%rax
  80227a:	48 98                	cltq
}
  80227c:	5d                   	pop    %rbp
  80227d:	c3                   	ret
        return -E_INVAL;
  80227e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802285:	c3                   	ret

0000000000802286 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802286:	f3 0f 1e fa          	endbr64
  80228a:	55                   	push   %rbp
  80228b:	48 89 e5             	mov    %rsp,%rbp
  80228e:	41 55                	push   %r13
  802290:	41 54                	push   %r12
  802292:	53                   	push   %rbx
  802293:	48 83 ec 08          	sub    $0x8,%rsp
  802297:	49 89 f4             	mov    %rsi,%r12
  80229a:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80229d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022a4:	00 00 00 
  8022a7:	8b 57 0c             	mov    0xc(%rdi),%edx
  8022aa:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8022ac:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8022b0:	be 00 00 00 00       	mov    $0x0,%esi
  8022b5:	bf 03 00 00 00       	mov    $0x3,%edi
  8022ba:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  8022c1:	00 00 00 
  8022c4:	ff d0                	call   *%rax
  8022c6:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8022c9:	4d 85 ed             	test   %r13,%r13
  8022cc:	78 2a                	js     8022f8 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8022ce:	4c 89 ea             	mov    %r13,%rdx
  8022d1:	4c 39 eb             	cmp    %r13,%rbx
  8022d4:	72 30                	jb     802306 <devfile_read+0x80>
  8022d6:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8022dd:	7f 27                	jg     802306 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8022df:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8022e6:	00 00 00 
  8022e9:	4c 89 e7             	mov    %r12,%rdi
  8022ec:	48 b8 ae 0e 80 00 00 	movabs $0x800eae,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	call   *%rax
}
  8022f8:	4c 89 e8             	mov    %r13,%rax
  8022fb:	48 83 c4 08          	add    $0x8,%rsp
  8022ff:	5b                   	pop    %rbx
  802300:	41 5c                	pop    %r12
  802302:	41 5d                	pop    %r13
  802304:	5d                   	pop    %rbp
  802305:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802306:	48 b9 55 42 80 00 00 	movabs $0x804255,%rcx
  80230d:	00 00 00 
  802310:	48 ba 07 42 80 00 00 	movabs $0x804207,%rdx
  802317:	00 00 00 
  80231a:	be 7b 00 00 00       	mov    $0x7b,%esi
  80231f:	48 bf 72 42 80 00 00 	movabs $0x804272,%rdi
  802326:	00 00 00 
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
  80232e:	49 b8 ee 01 80 00 00 	movabs $0x8001ee,%r8
  802335:	00 00 00 
  802338:	41 ff d0             	call   *%r8

000000000080233b <open>:
open(const char *path, int mode) {
  80233b:	f3 0f 1e fa          	endbr64
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
  802343:	41 55                	push   %r13
  802345:	41 54                	push   %r12
  802347:	53                   	push   %rbx
  802348:	48 83 ec 18          	sub    $0x18,%rsp
  80234c:	49 89 fc             	mov    %rdi,%r12
  80234f:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802352:	48 b8 4e 0c 80 00 00 	movabs $0x800c4e,%rax
  802359:	00 00 00 
  80235c:	ff d0                	call   *%rax
  80235e:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802364:	0f 87 8a 00 00 00    	ja     8023f4 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80236a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80236e:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  802375:	00 00 00 
  802378:	ff d0                	call   *%rax
  80237a:	89 c3                	mov    %eax,%ebx
  80237c:	85 c0                	test   %eax,%eax
  80237e:	78 50                	js     8023d0 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802380:	4c 89 e6             	mov    %r12,%rsi
  802383:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80238a:	00 00 00 
  80238d:	48 89 df             	mov    %rbx,%rdi
  802390:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  802397:	00 00 00 
  80239a:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80239c:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8023a3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023a7:	bf 01 00 00 00       	mov    $0x1,%edi
  8023ac:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  8023b3:	00 00 00 
  8023b6:	ff d0                	call   *%rax
  8023b8:	89 c3                	mov    %eax,%ebx
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	78 1f                	js     8023dd <open+0xa2>
    return fd2num(fd);
  8023be:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023c2:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	call   *%rax
  8023ce:	89 c3                	mov    %eax,%ebx
}
  8023d0:	89 d8                	mov    %ebx,%eax
  8023d2:	48 83 c4 18          	add    $0x18,%rsp
  8023d6:	5b                   	pop    %rbx
  8023d7:	41 5c                	pop    %r12
  8023d9:	41 5d                	pop    %r13
  8023db:	5d                   	pop    %rbp
  8023dc:	c3                   	ret
        fd_close(fd, 0);
  8023dd:	be 00 00 00 00       	mov    $0x0,%esi
  8023e2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023e6:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	call   *%rax
        return res;
  8023f2:	eb dc                	jmp    8023d0 <open+0x95>
        return -E_BAD_PATH;
  8023f4:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023f9:	eb d5                	jmp    8023d0 <open+0x95>

00000000008023fb <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023fb:	f3 0f 1e fa          	endbr64
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802403:	be 00 00 00 00       	mov    $0x0,%esi
  802408:	bf 08 00 00 00       	mov    $0x8,%edi
  80240d:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  802414:	00 00 00 
  802417:	ff d0                	call   *%rax
}
  802419:	5d                   	pop    %rbp
  80241a:	c3                   	ret

000000000080241b <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80241b:	f3 0f 1e fa          	endbr64
  80241f:	55                   	push   %rbp
  802420:	48 89 e5             	mov    %rsp,%rbp
  802423:	41 54                	push   %r12
  802425:	53                   	push   %rbx
  802426:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802429:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  802430:	00 00 00 
  802433:	ff d0                	call   *%rax
  802435:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802438:	48 be 7d 42 80 00 00 	movabs $0x80427d,%rsi
  80243f:	00 00 00 
  802442:	48 89 df             	mov    %rbx,%rdi
  802445:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  80244c:	00 00 00 
  80244f:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802451:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802456:	41 2b 04 24          	sub    (%r12),%eax
  80245a:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802460:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802467:	00 00 00 
    stat->st_dev = &devpipe;
  80246a:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802471:	00 00 00 
  802474:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	5b                   	pop    %rbx
  802481:	41 5c                	pop    %r12
  802483:	5d                   	pop    %rbp
  802484:	c3                   	ret

0000000000802485 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802485:	f3 0f 1e fa          	endbr64
  802489:	55                   	push   %rbp
  80248a:	48 89 e5             	mov    %rsp,%rbp
  80248d:	41 54                	push   %r12
  80248f:	53                   	push   %rbx
  802490:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802493:	ba 00 10 00 00       	mov    $0x1000,%edx
  802498:	48 89 fe             	mov    %rdi,%rsi
  80249b:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a0:	49 bc d8 13 80 00 00 	movabs $0x8013d8,%r12
  8024a7:	00 00 00 
  8024aa:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8024ad:	48 89 df             	mov    %rbx,%rdi
  8024b0:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  8024b7:	00 00 00 
  8024ba:	ff d0                	call   *%rax
  8024bc:	48 89 c6             	mov    %rax,%rsi
  8024bf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c9:	41 ff d4             	call   *%r12
}
  8024cc:	5b                   	pop    %rbx
  8024cd:	41 5c                	pop    %r12
  8024cf:	5d                   	pop    %rbp
  8024d0:	c3                   	ret

00000000008024d1 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024d1:	f3 0f 1e fa          	endbr64
  8024d5:	55                   	push   %rbp
  8024d6:	48 89 e5             	mov    %rsp,%rbp
  8024d9:	41 57                	push   %r15
  8024db:	41 56                	push   %r14
  8024dd:	41 55                	push   %r13
  8024df:	41 54                	push   %r12
  8024e1:	53                   	push   %rbx
  8024e2:	48 83 ec 18          	sub    $0x18,%rsp
  8024e6:	49 89 fc             	mov    %rdi,%r12
  8024e9:	49 89 f5             	mov    %rsi,%r13
  8024ec:	49 89 d7             	mov    %rdx,%r15
  8024ef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024f3:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8024ff:	4d 85 ff             	test   %r15,%r15
  802502:	0f 84 af 00 00 00    	je     8025b7 <devpipe_write+0xe6>
  802508:	48 89 c3             	mov    %rax,%rbx
  80250b:	4c 89 f8             	mov    %r15,%rax
  80250e:	4d 89 ef             	mov    %r13,%r15
  802511:	4c 01 e8             	add    %r13,%rax
  802514:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802518:	49 bd 68 12 80 00 00 	movabs $0x801268,%r13
  80251f:	00 00 00 
            sys_yield();
  802522:	49 be fd 11 80 00 00 	movabs $0x8011fd,%r14
  802529:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80252c:	8b 73 04             	mov    0x4(%rbx),%esi
  80252f:	48 63 ce             	movslq %esi,%rcx
  802532:	48 63 03             	movslq (%rbx),%rax
  802535:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80253b:	48 39 c1             	cmp    %rax,%rcx
  80253e:	72 2e                	jb     80256e <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802540:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802545:	48 89 da             	mov    %rbx,%rdx
  802548:	be 00 10 00 00       	mov    $0x1000,%esi
  80254d:	4c 89 e7             	mov    %r12,%rdi
  802550:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802553:	85 c0                	test   %eax,%eax
  802555:	74 66                	je     8025bd <devpipe_write+0xec>
            sys_yield();
  802557:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80255a:	8b 73 04             	mov    0x4(%rbx),%esi
  80255d:	48 63 ce             	movslq %esi,%rcx
  802560:	48 63 03             	movslq (%rbx),%rax
  802563:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802569:	48 39 c1             	cmp    %rax,%rcx
  80256c:	73 d2                	jae    802540 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80256e:	41 0f b6 3f          	movzbl (%r15),%edi
  802572:	48 89 ca             	mov    %rcx,%rdx
  802575:	48 c1 ea 03          	shr    $0x3,%rdx
  802579:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802580:	08 10 20 
  802583:	48 f7 e2             	mul    %rdx
  802586:	48 c1 ea 06          	shr    $0x6,%rdx
  80258a:	48 89 d0             	mov    %rdx,%rax
  80258d:	48 c1 e0 09          	shl    $0x9,%rax
  802591:	48 29 d0             	sub    %rdx,%rax
  802594:	48 c1 e0 03          	shl    $0x3,%rax
  802598:	48 29 c1             	sub    %rax,%rcx
  80259b:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8025a0:	83 c6 01             	add    $0x1,%esi
  8025a3:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025a6:	49 83 c7 01          	add    $0x1,%r15
  8025aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8025ae:	49 39 c7             	cmp    %rax,%r15
  8025b1:	0f 85 75 ff ff ff    	jne    80252c <devpipe_write+0x5b>
    return n;
  8025b7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8025bb:	eb 05                	jmp    8025c2 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c2:	48 83 c4 18          	add    $0x18,%rsp
  8025c6:	5b                   	pop    %rbx
  8025c7:	41 5c                	pop    %r12
  8025c9:	41 5d                	pop    %r13
  8025cb:	41 5e                	pop    %r14
  8025cd:	41 5f                	pop    %r15
  8025cf:	5d                   	pop    %rbp
  8025d0:	c3                   	ret

00000000008025d1 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025d1:	f3 0f 1e fa          	endbr64
  8025d5:	55                   	push   %rbp
  8025d6:	48 89 e5             	mov    %rsp,%rbp
  8025d9:	41 57                	push   %r15
  8025db:	41 56                	push   %r14
  8025dd:	41 55                	push   %r13
  8025df:	41 54                	push   %r12
  8025e1:	53                   	push   %rbx
  8025e2:	48 83 ec 18          	sub    $0x18,%rsp
  8025e6:	49 89 fc             	mov    %rdi,%r12
  8025e9:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8025ed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025f1:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	call   *%rax
  8025fd:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802600:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802606:	49 bd 68 12 80 00 00 	movabs $0x801268,%r13
  80260d:	00 00 00 
            sys_yield();
  802610:	49 be fd 11 80 00 00 	movabs $0x8011fd,%r14
  802617:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80261a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80261f:	74 7d                	je     80269e <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802621:	8b 03                	mov    (%rbx),%eax
  802623:	3b 43 04             	cmp    0x4(%rbx),%eax
  802626:	75 26                	jne    80264e <devpipe_read+0x7d>
            if (i > 0) return i;
  802628:	4d 85 ff             	test   %r15,%r15
  80262b:	75 77                	jne    8026a4 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80262d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802632:	48 89 da             	mov    %rbx,%rdx
  802635:	be 00 10 00 00       	mov    $0x1000,%esi
  80263a:	4c 89 e7             	mov    %r12,%rdi
  80263d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802640:	85 c0                	test   %eax,%eax
  802642:	74 72                	je     8026b6 <devpipe_read+0xe5>
            sys_yield();
  802644:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802647:	8b 03                	mov    (%rbx),%eax
  802649:	3b 43 04             	cmp    0x4(%rbx),%eax
  80264c:	74 df                	je     80262d <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80264e:	48 63 c8             	movslq %eax,%rcx
  802651:	48 89 ca             	mov    %rcx,%rdx
  802654:	48 c1 ea 03          	shr    $0x3,%rdx
  802658:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80265f:	08 10 20 
  802662:	48 89 d0             	mov    %rdx,%rax
  802665:	48 f7 e6             	mul    %rsi
  802668:	48 c1 ea 06          	shr    $0x6,%rdx
  80266c:	48 89 d0             	mov    %rdx,%rax
  80266f:	48 c1 e0 09          	shl    $0x9,%rax
  802673:	48 29 d0             	sub    %rdx,%rax
  802676:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80267d:	00 
  80267e:	48 89 c8             	mov    %rcx,%rax
  802681:	48 29 d0             	sub    %rdx,%rax
  802684:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802689:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80268d:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802691:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802694:	49 83 c7 01          	add    $0x1,%r15
  802698:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80269c:	75 83                	jne    802621 <devpipe_read+0x50>
    return n;
  80269e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026a2:	eb 03                	jmp    8026a7 <devpipe_read+0xd6>
            if (i > 0) return i;
  8026a4:	4c 89 f8             	mov    %r15,%rax
}
  8026a7:	48 83 c4 18          	add    $0x18,%rsp
  8026ab:	5b                   	pop    %rbx
  8026ac:	41 5c                	pop    %r12
  8026ae:	41 5d                	pop    %r13
  8026b0:	41 5e                	pop    %r14
  8026b2:	41 5f                	pop    %r15
  8026b4:	5d                   	pop    %rbp
  8026b5:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bb:	eb ea                	jmp    8026a7 <devpipe_read+0xd6>

00000000008026bd <pipe>:
pipe(int pfd[2]) {
  8026bd:	f3 0f 1e fa          	endbr64
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	41 55                	push   %r13
  8026c7:	41 54                	push   %r12
  8026c9:	53                   	push   %rbx
  8026ca:	48 83 ec 18          	sub    $0x18,%rsp
  8026ce:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026d1:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026d5:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	call   *%rax
  8026e1:	89 c3                	mov    %eax,%ebx
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	0f 88 a0 01 00 00    	js     80288b <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8026eb:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026f5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fe:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  802705:	00 00 00 
  802708:	ff d0                	call   *%rax
  80270a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80270c:	85 c0                	test   %eax,%eax
  80270e:	0f 88 77 01 00 00    	js     80288b <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802714:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802718:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  80271f:	00 00 00 
  802722:	ff d0                	call   *%rax
  802724:	89 c3                	mov    %eax,%ebx
  802726:	85 c0                	test   %eax,%eax
  802728:	0f 88 43 01 00 00    	js     802871 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80272e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802733:	ba 00 10 00 00       	mov    $0x1000,%edx
  802738:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80273c:	bf 00 00 00 00       	mov    $0x0,%edi
  802741:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  802748:	00 00 00 
  80274b:	ff d0                	call   *%rax
  80274d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80274f:	85 c0                	test   %eax,%eax
  802751:	0f 88 1a 01 00 00    	js     802871 <pipe+0x1b4>
    va = fd2data(fd0);
  802757:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80275b:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  802762:	00 00 00 
  802765:	ff d0                	call   *%rax
  802767:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80276a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80276f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802774:	48 89 c6             	mov    %rax,%rsi
  802777:	bf 00 00 00 00       	mov    $0x0,%edi
  80277c:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  802783:	00 00 00 
  802786:	ff d0                	call   *%rax
  802788:	89 c3                	mov    %eax,%ebx
  80278a:	85 c0                	test   %eax,%eax
  80278c:	0f 88 c5 00 00 00    	js     802857 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802792:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802796:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	call   *%rax
  8027a2:	48 89 c1             	mov    %rax,%rcx
  8027a5:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8027ab:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8027b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b6:	4c 89 ee             	mov    %r13,%rsi
  8027b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027be:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	call   *%rax
  8027ca:	89 c3                	mov    %eax,%ebx
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	78 6e                	js     80283e <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027d0:	be 00 10 00 00       	mov    $0x1000,%esi
  8027d5:	4c 89 ef             	mov    %r13,%rdi
  8027d8:	48 b8 32 12 80 00 00 	movabs $0x801232,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	call   *%rax
  8027e4:	83 f8 02             	cmp    $0x2,%eax
  8027e7:	0f 85 ab 00 00 00    	jne    802898 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8027ed:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8027f4:	00 00 
  8027f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027fa:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8027fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802800:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802807:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80280b:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80280d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802811:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802818:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80281c:	48 bb 70 19 80 00 00 	movabs $0x801970,%rbx
  802823:	00 00 00 
  802826:	ff d3                	call   *%rbx
  802828:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80282c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802830:	ff d3                	call   *%rbx
  802832:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802837:	bb 00 00 00 00       	mov    $0x0,%ebx
  80283c:	eb 4d                	jmp    80288b <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80283e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802843:	4c 89 ee             	mov    %r13,%rsi
  802846:	bf 00 00 00 00       	mov    $0x0,%edi
  80284b:	48 b8 d8 13 80 00 00 	movabs $0x8013d8,%rax
  802852:	00 00 00 
  802855:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802857:	ba 00 10 00 00       	mov    $0x1000,%edx
  80285c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802860:	bf 00 00 00 00       	mov    $0x0,%edi
  802865:	48 b8 d8 13 80 00 00 	movabs $0x8013d8,%rax
  80286c:	00 00 00 
  80286f:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802871:	ba 00 10 00 00       	mov    $0x1000,%edx
  802876:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80287a:	bf 00 00 00 00       	mov    $0x0,%edi
  80287f:	48 b8 d8 13 80 00 00 	movabs $0x8013d8,%rax
  802886:	00 00 00 
  802889:	ff d0                	call   *%rax
}
  80288b:	89 d8                	mov    %ebx,%eax
  80288d:	48 83 c4 18          	add    $0x18,%rsp
  802891:	5b                   	pop    %rbx
  802892:	41 5c                	pop    %r12
  802894:	41 5d                	pop    %r13
  802896:	5d                   	pop    %rbp
  802897:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802898:	48 b9 f0 43 80 00 00 	movabs $0x8043f0,%rcx
  80289f:	00 00 00 
  8028a2:	48 ba 07 42 80 00 00 	movabs $0x804207,%rdx
  8028a9:	00 00 00 
  8028ac:	be 2e 00 00 00       	mov    $0x2e,%esi
  8028b1:	48 bf 84 42 80 00 00 	movabs $0x804284,%rdi
  8028b8:	00 00 00 
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	49 b8 ee 01 80 00 00 	movabs $0x8001ee,%r8
  8028c7:	00 00 00 
  8028ca:	41 ff d0             	call   *%r8

00000000008028cd <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028cd:	f3 0f 1e fa          	endbr64
  8028d1:	55                   	push   %rbp
  8028d2:	48 89 e5             	mov    %rsp,%rbp
  8028d5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028d9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028dd:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	78 35                	js     802922 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8028ed:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028f1:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	call   *%rax
  8028fd:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802900:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802905:	be 00 10 00 00       	mov    $0x1000,%esi
  80290a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80290e:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  802915:	00 00 00 
  802918:	ff d0                	call   *%rax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	0f 94 c0             	sete   %al
  80291f:	0f b6 c0             	movzbl %al,%eax
}
  802922:	c9                   	leave
  802923:	c3                   	ret

0000000000802924 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802924:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802928:	48 89 f8             	mov    %rdi,%rax
  80292b:	48 c1 e8 27          	shr    $0x27,%rax
  80292f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802936:	7f 00 00 
  802939:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80293d:	f6 c2 01             	test   $0x1,%dl
  802940:	74 6d                	je     8029af <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802942:	48 89 f8             	mov    %rdi,%rax
  802945:	48 c1 e8 1e          	shr    $0x1e,%rax
  802949:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802950:	7f 00 00 
  802953:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802957:	f6 c2 01             	test   $0x1,%dl
  80295a:	74 62                	je     8029be <get_uvpt_entry+0x9a>
  80295c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802963:	7f 00 00 
  802966:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80296a:	f6 c2 80             	test   $0x80,%dl
  80296d:	75 4f                	jne    8029be <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80296f:	48 89 f8             	mov    %rdi,%rax
  802972:	48 c1 e8 15          	shr    $0x15,%rax
  802976:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80297d:	7f 00 00 
  802980:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802984:	f6 c2 01             	test   $0x1,%dl
  802987:	74 44                	je     8029cd <get_uvpt_entry+0xa9>
  802989:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802990:	7f 00 00 
  802993:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802997:	f6 c2 80             	test   $0x80,%dl
  80299a:	75 31                	jne    8029cd <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80299c:	48 c1 ef 0c          	shr    $0xc,%rdi
  8029a0:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029a7:	7f 00 00 
  8029aa:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8029ae:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029af:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029b6:	7f 00 00 
  8029b9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029bd:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029be:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029c5:	7f 00 00 
  8029c8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029cc:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029cd:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029d4:	7f 00 00 
  8029d7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029db:	c3                   	ret

00000000008029dc <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8029dc:	f3 0f 1e fa          	endbr64
  8029e0:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029e3:	48 89 f9             	mov    %rdi,%rcx
  8029e6:	48 c1 e9 27          	shr    $0x27,%rcx
  8029ea:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8029f1:	7f 00 00 
  8029f4:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8029f8:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029ff:	f6 c1 01             	test   $0x1,%cl
  802a02:	0f 84 b2 00 00 00    	je     802aba <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a08:	48 89 f9             	mov    %rdi,%rcx
  802a0b:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802a0f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a16:	7f 00 00 
  802a19:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a1d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a24:	40 f6 c6 01          	test   $0x1,%sil
  802a28:	0f 84 8c 00 00 00    	je     802aba <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802a2e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a35:	7f 00 00 
  802a38:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a3c:	a8 80                	test   $0x80,%al
  802a3e:	75 7b                	jne    802abb <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802a40:	48 89 f9             	mov    %rdi,%rcx
  802a43:	48 c1 e9 15          	shr    $0x15,%rcx
  802a47:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a4e:	7f 00 00 
  802a51:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a55:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802a5c:	40 f6 c6 01          	test   $0x1,%sil
  802a60:	74 58                	je     802aba <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802a62:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a69:	7f 00 00 
  802a6c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a70:	a8 80                	test   $0x80,%al
  802a72:	75 6c                	jne    802ae0 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802a74:	48 89 f9             	mov    %rdi,%rcx
  802a77:	48 c1 e9 0c          	shr    $0xc,%rcx
  802a7b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a82:	7f 00 00 
  802a85:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a89:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802a90:	40 f6 c6 01          	test   $0x1,%sil
  802a94:	74 24                	je     802aba <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802a96:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a9d:	7f 00 00 
  802aa0:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802aa4:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802aab:	ff ff 7f 
  802aae:	48 21 c8             	and    %rcx,%rax
  802ab1:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802ab7:	48 09 d0             	or     %rdx,%rax
}
  802aba:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802abb:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ac2:	7f 00 00 
  802ac5:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ac9:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ad0:	ff ff 7f 
  802ad3:	48 21 c8             	and    %rcx,%rax
  802ad6:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802adc:	48 01 d0             	add    %rdx,%rax
  802adf:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802ae0:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802ae7:	7f 00 00 
  802aea:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802aee:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802af5:	ff ff 7f 
  802af8:	48 21 c8             	and    %rcx,%rax
  802afb:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802b01:	48 01 d0             	add    %rdx,%rax
  802b04:	c3                   	ret

0000000000802b05 <get_prot>:

int
get_prot(void *va) {
  802b05:	f3 0f 1e fa          	endbr64
  802b09:	55                   	push   %rbp
  802b0a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b0d:	48 b8 24 29 80 00 00 	movabs $0x802924,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	call   *%rax
  802b19:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802b1c:	83 e0 01             	and    $0x1,%eax
  802b1f:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802b22:	89 d1                	mov    %edx,%ecx
  802b24:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802b2a:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b2c:	89 c1                	mov    %eax,%ecx
  802b2e:	83 c9 02             	or     $0x2,%ecx
  802b31:	f6 c2 02             	test   $0x2,%dl
  802b34:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b37:	89 c1                	mov    %eax,%ecx
  802b39:	83 c9 01             	or     $0x1,%ecx
  802b3c:	48 85 d2             	test   %rdx,%rdx
  802b3f:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b42:	89 c1                	mov    %eax,%ecx
  802b44:	83 c9 40             	or     $0x40,%ecx
  802b47:	f6 c6 04             	test   $0x4,%dh
  802b4a:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b4d:	5d                   	pop    %rbp
  802b4e:	c3                   	ret

0000000000802b4f <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b4f:	f3 0f 1e fa          	endbr64
  802b53:	55                   	push   %rbp
  802b54:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b57:	48 b8 24 29 80 00 00 	movabs $0x802924,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b63:	48 c1 e8 06          	shr    $0x6,%rax
  802b67:	83 e0 01             	and    $0x1,%eax
}
  802b6a:	5d                   	pop    %rbp
  802b6b:	c3                   	ret

0000000000802b6c <is_page_present>:

bool
is_page_present(void *va) {
  802b6c:	f3 0f 1e fa          	endbr64
  802b70:	55                   	push   %rbp
  802b71:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b74:	48 b8 24 29 80 00 00 	movabs $0x802924,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	call   *%rax
  802b80:	83 e0 01             	and    $0x1,%eax
}
  802b83:	5d                   	pop    %rbp
  802b84:	c3                   	ret

0000000000802b85 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b85:	f3 0f 1e fa          	endbr64
  802b89:	55                   	push   %rbp
  802b8a:	48 89 e5             	mov    %rsp,%rbp
  802b8d:	41 57                	push   %r15
  802b8f:	41 56                	push   %r14
  802b91:	41 55                	push   %r13
  802b93:	41 54                	push   %r12
  802b95:	53                   	push   %rbx
  802b96:	48 83 ec 18          	sub    $0x18,%rsp
  802b9a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802b9e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802ba2:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802ba7:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802bae:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802bb1:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802bb8:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802bbb:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802bc2:	00 00 00 
  802bc5:	eb 73                	jmp    802c3a <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802bc7:	48 89 d8             	mov    %rbx,%rax
  802bca:	48 c1 e8 15          	shr    $0x15,%rax
  802bce:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802bd5:	7f 00 00 
  802bd8:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802bdc:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802be2:	f6 c2 01             	test   $0x1,%dl
  802be5:	74 4b                	je     802c32 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802be7:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802beb:	f6 c2 80             	test   $0x80,%dl
  802bee:	74 11                	je     802c01 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802bf0:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802bf4:	f6 c4 04             	test   $0x4,%ah
  802bf7:	74 39                	je     802c32 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802bf9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802bff:	eb 20                	jmp    802c21 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c01:	48 89 da             	mov    %rbx,%rdx
  802c04:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c08:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802c0f:	7f 00 00 
  802c12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802c16:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c1c:	f6 c4 04             	test   $0x4,%ah
  802c1f:	74 11                	je     802c32 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802c21:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802c25:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c29:	48 89 df             	mov    %rbx,%rdi
  802c2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c30:	ff d0                	call   *%rax
    next:
        va += size;
  802c32:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802c35:	49 39 df             	cmp    %rbx,%r15
  802c38:	72 3e                	jb     802c78 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c3a:	49 8b 06             	mov    (%r14),%rax
  802c3d:	a8 01                	test   $0x1,%al
  802c3f:	74 37                	je     802c78 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c41:	48 89 d8             	mov    %rbx,%rax
  802c44:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c48:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802c4d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c53:	f6 c2 01             	test   $0x1,%dl
  802c56:	74 da                	je     802c32 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802c58:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802c5d:	f6 c2 80             	test   $0x80,%dl
  802c60:	0f 84 61 ff ff ff    	je     802bc7 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802c66:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c6b:	f6 c4 04             	test   $0x4,%ah
  802c6e:	74 c2                	je     802c32 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802c70:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802c76:	eb a9                	jmp    802c21 <foreach_shared_region+0x9c>
    }
    return res;
}
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7d:	48 83 c4 18          	add    $0x18,%rsp
  802c81:	5b                   	pop    %rbx
  802c82:	41 5c                	pop    %r12
  802c84:	41 5d                	pop    %r13
  802c86:	41 5e                	pop    %r14
  802c88:	41 5f                	pop    %r15
  802c8a:	5d                   	pop    %rbp
  802c8b:	c3                   	ret

0000000000802c8c <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802c8c:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax
  802c95:	c3                   	ret

0000000000802c96 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802c96:	f3 0f 1e fa          	endbr64
  802c9a:	55                   	push   %rbp
  802c9b:	48 89 e5             	mov    %rsp,%rbp
  802c9e:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802ca1:	48 be 94 42 80 00 00 	movabs $0x804294,%rsi
  802ca8:	00 00 00 
  802cab:	48 b8 93 0c 80 00 00 	movabs $0x800c93,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	call   *%rax
    return 0;
}
  802cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbc:	5d                   	pop    %rbp
  802cbd:	c3                   	ret

0000000000802cbe <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802cbe:	f3 0f 1e fa          	endbr64
  802cc2:	55                   	push   %rbp
  802cc3:	48 89 e5             	mov    %rsp,%rbp
  802cc6:	41 57                	push   %r15
  802cc8:	41 56                	push   %r14
  802cca:	41 55                	push   %r13
  802ccc:	41 54                	push   %r12
  802cce:	53                   	push   %rbx
  802ccf:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802cd6:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cdd:	48 85 d2             	test   %rdx,%rdx
  802ce0:	74 7a                	je     802d5c <devcons_write+0x9e>
  802ce2:	49 89 d6             	mov    %rdx,%r14
  802ce5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ceb:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802cf0:	49 bf ae 0e 80 00 00 	movabs $0x800eae,%r15
  802cf7:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802cfa:	4c 89 f3             	mov    %r14,%rbx
  802cfd:	48 29 f3             	sub    %rsi,%rbx
  802d00:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d05:	48 39 c3             	cmp    %rax,%rbx
  802d08:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802d0c:	4c 63 eb             	movslq %ebx,%r13
  802d0f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802d16:	48 01 c6             	add    %rax,%rsi
  802d19:	4c 89 ea             	mov    %r13,%rdx
  802d1c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d23:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802d26:	4c 89 ee             	mov    %r13,%rsi
  802d29:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d30:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d3c:	41 01 dc             	add    %ebx,%r12d
  802d3f:	49 63 f4             	movslq %r12d,%rsi
  802d42:	4c 39 f6             	cmp    %r14,%rsi
  802d45:	72 b3                	jb     802cfa <devcons_write+0x3c>
    return res;
  802d47:	49 63 c4             	movslq %r12d,%rax
}
  802d4a:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d51:	5b                   	pop    %rbx
  802d52:	41 5c                	pop    %r12
  802d54:	41 5d                	pop    %r13
  802d56:	41 5e                	pop    %r14
  802d58:	41 5f                	pop    %r15
  802d5a:	5d                   	pop    %rbp
  802d5b:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802d5c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d62:	eb e3                	jmp    802d47 <devcons_write+0x89>

0000000000802d64 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d64:	f3 0f 1e fa          	endbr64
  802d68:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d70:	48 85 c0             	test   %rax,%rax
  802d73:	74 55                	je     802dca <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d75:	55                   	push   %rbp
  802d76:	48 89 e5             	mov    %rsp,%rbp
  802d79:	41 55                	push   %r13
  802d7b:	41 54                	push   %r12
  802d7d:	53                   	push   %rbx
  802d7e:	48 83 ec 08          	sub    $0x8,%rsp
  802d82:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d85:	48 bb 24 11 80 00 00 	movabs $0x801124,%rbx
  802d8c:	00 00 00 
  802d8f:	49 bc fd 11 80 00 00 	movabs $0x8011fd,%r12
  802d96:	00 00 00 
  802d99:	eb 03                	jmp    802d9e <devcons_read+0x3a>
  802d9b:	41 ff d4             	call   *%r12
  802d9e:	ff d3                	call   *%rbx
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 f7                	je     802d9b <devcons_read+0x37>
    if (c < 0) return c;
  802da4:	48 63 d0             	movslq %eax,%rdx
  802da7:	78 13                	js     802dbc <devcons_read+0x58>
    if (c == 0x04) return 0;
  802da9:	ba 00 00 00 00       	mov    $0x0,%edx
  802dae:	83 f8 04             	cmp    $0x4,%eax
  802db1:	74 09                	je     802dbc <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802db3:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802db7:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802dbc:	48 89 d0             	mov    %rdx,%rax
  802dbf:	48 83 c4 08          	add    $0x8,%rsp
  802dc3:	5b                   	pop    %rbx
  802dc4:	41 5c                	pop    %r12
  802dc6:	41 5d                	pop    %r13
  802dc8:	5d                   	pop    %rbp
  802dc9:	c3                   	ret
  802dca:	48 89 d0             	mov    %rdx,%rax
  802dcd:	c3                   	ret

0000000000802dce <cputchar>:
cputchar(int ch) {
  802dce:	f3 0f 1e fa          	endbr64
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802dda:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802dde:	be 01 00 00 00       	mov    $0x1,%esi
  802de3:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802de7:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  802dee:	00 00 00 
  802df1:	ff d0                	call   *%rax
}
  802df3:	c9                   	leave
  802df4:	c3                   	ret

0000000000802df5 <getchar>:
getchar(void) {
  802df5:	f3 0f 1e fa          	endbr64
  802df9:	55                   	push   %rbp
  802dfa:	48 89 e5             	mov    %rsp,%rbp
  802dfd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e01:	ba 01 00 00 00       	mov    $0x1,%edx
  802e06:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0f:	48 b8 05 1d 80 00 00 	movabs $0x801d05,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	call   *%rax
  802e1b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	78 06                	js     802e27 <getchar+0x32>
  802e21:	74 08                	je     802e2b <getchar+0x36>
  802e23:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e27:	89 d0                	mov    %edx,%eax
  802e29:	c9                   	leave
  802e2a:	c3                   	ret
    return res < 0 ? res : res ? c :
  802e2b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e30:	eb f5                	jmp    802e27 <getchar+0x32>

0000000000802e32 <iscons>:
iscons(int fdnum) {
  802e32:	f3 0f 1e fa          	endbr64
  802e36:	55                   	push   %rbp
  802e37:	48 89 e5             	mov    %rsp,%rbp
  802e3a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e3e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e42:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	78 18                	js     802e6a <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802e52:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e56:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802e5d:	00 00 00 
  802e60:	8b 00                	mov    (%rax),%eax
  802e62:	39 02                	cmp    %eax,(%rdx)
  802e64:	0f 94 c0             	sete   %al
  802e67:	0f b6 c0             	movzbl %al,%eax
}
  802e6a:	c9                   	leave
  802e6b:	c3                   	ret

0000000000802e6c <opencons>:
opencons(void) {
  802e6c:	f3 0f 1e fa          	endbr64
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
  802e74:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e78:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e7c:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  802e83:	00 00 00 
  802e86:	ff d0                	call   *%rax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	78 49                	js     802ed5 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802e8c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e91:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e96:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802e9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9f:	48 b8 98 12 80 00 00 	movabs $0x801298,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	call   *%rax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	78 26                	js     802ed5 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802eaf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802eb3:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802eba:	00 00 
  802ebc:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ebe:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ec2:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802ec9:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  802ed0:	00 00 00 
  802ed3:	ff d0                	call   *%rax
}
  802ed5:	c9                   	leave
  802ed6:	c3                   	ret

0000000000802ed7 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ed7:	f3 0f 1e fa          	endbr64
  802edb:	55                   	push   %rbp
  802edc:	48 89 e5             	mov    %rsp,%rbp
  802edf:	41 54                	push   %r12
  802ee1:	53                   	push   %rbx
  802ee2:	48 89 fb             	mov    %rdi,%rbx
  802ee5:	48 89 f7             	mov    %rsi,%rdi
  802ee8:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802eeb:	48 85 f6             	test   %rsi,%rsi
  802eee:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ef5:	00 00 00 
  802ef8:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802efc:	be 00 10 00 00       	mov    $0x1000,%esi
  802f01:	48 b8 ba 15 80 00 00 	movabs $0x8015ba,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	call   *%rax
    if (res < 0) {
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	78 45                	js     802f56 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802f11:	48 85 db             	test   %rbx,%rbx
  802f14:	74 12                	je     802f28 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802f16:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f1d:	00 00 00 
  802f20:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802f26:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802f28:	4d 85 e4             	test   %r12,%r12
  802f2b:	74 14                	je     802f41 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802f2d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f34:	00 00 00 
  802f37:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802f3d:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802f41:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f48:	00 00 00 
  802f4b:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802f51:	5b                   	pop    %rbx
  802f52:	41 5c                	pop    %r12
  802f54:	5d                   	pop    %rbp
  802f55:	c3                   	ret
        if (from_env_store != NULL) {
  802f56:	48 85 db             	test   %rbx,%rbx
  802f59:	74 06                	je     802f61 <ipc_recv+0x8a>
            *from_env_store = 0;
  802f5b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802f61:	4d 85 e4             	test   %r12,%r12
  802f64:	74 eb                	je     802f51 <ipc_recv+0x7a>
            *perm_store = 0;
  802f66:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802f6d:	00 
  802f6e:	eb e1                	jmp    802f51 <ipc_recv+0x7a>

0000000000802f70 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802f70:	f3 0f 1e fa          	endbr64
  802f74:	55                   	push   %rbp
  802f75:	48 89 e5             	mov    %rsp,%rbp
  802f78:	41 57                	push   %r15
  802f7a:	41 56                	push   %r14
  802f7c:	41 55                	push   %r13
  802f7e:	41 54                	push   %r12
  802f80:	53                   	push   %rbx
  802f81:	48 83 ec 18          	sub    $0x18,%rsp
  802f85:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802f88:	48 89 d3             	mov    %rdx,%rbx
  802f8b:	49 89 cc             	mov    %rcx,%r12
  802f8e:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f91:	48 85 d2             	test   %rdx,%rdx
  802f94:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f9b:	00 00 00 
  802f9e:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fa2:	89 f0                	mov    %esi,%eax
  802fa4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802fa8:	48 89 da             	mov    %rbx,%rdx
  802fab:	48 89 c6             	mov    %rax,%rsi
  802fae:	48 b8 8a 15 80 00 00 	movabs $0x80158a,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	call   *%rax
    while (res < 0) {
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	79 65                	jns    803023 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802fbe:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802fc1:	75 33                	jne    802ff6 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802fc3:	49 bf fd 11 80 00 00 	movabs $0x8011fd,%r15
  802fca:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fcd:	49 be 8a 15 80 00 00 	movabs $0x80158a,%r14
  802fd4:	00 00 00 
        sys_yield();
  802fd7:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fda:	45 89 e8             	mov    %r13d,%r8d
  802fdd:	4c 89 e1             	mov    %r12,%rcx
  802fe0:	48 89 da             	mov    %rbx,%rdx
  802fe3:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802fe7:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802fea:	41 ff d6             	call   *%r14
    while (res < 0) {
  802fed:	85 c0                	test   %eax,%eax
  802fef:	79 32                	jns    803023 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802ff1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802ff4:	74 e1                	je     802fd7 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802ff6:	89 c1                	mov    %eax,%ecx
  802ff8:	48 ba a0 42 80 00 00 	movabs $0x8042a0,%rdx
  802fff:	00 00 00 
  803002:	be 42 00 00 00       	mov    $0x42,%esi
  803007:	48 bf ab 42 80 00 00 	movabs $0x8042ab,%rdi
  80300e:	00 00 00 
  803011:	b8 00 00 00 00       	mov    $0x0,%eax
  803016:	49 b8 ee 01 80 00 00 	movabs $0x8001ee,%r8
  80301d:	00 00 00 
  803020:	41 ff d0             	call   *%r8
    }
}
  803023:	48 83 c4 18          	add    $0x18,%rsp
  803027:	5b                   	pop    %rbx
  803028:	41 5c                	pop    %r12
  80302a:	41 5d                	pop    %r13
  80302c:	41 5e                	pop    %r14
  80302e:	41 5f                	pop    %r15
  803030:	5d                   	pop    %rbp
  803031:	c3                   	ret

0000000000803032 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803032:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803036:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80303b:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803042:	00 00 00 
  803045:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803049:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80304d:	48 c1 e2 04          	shl    $0x4,%rdx
  803051:	48 01 ca             	add    %rcx,%rdx
  803054:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80305a:	39 fa                	cmp    %edi,%edx
  80305c:	74 12                	je     803070 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  80305e:	48 83 c0 01          	add    $0x1,%rax
  803062:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803068:	75 db                	jne    803045 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  80306a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80306f:	c3                   	ret
            return envs[i].env_id;
  803070:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803074:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803078:	48 c1 e2 04          	shl    $0x4,%rdx
  80307c:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803083:	00 00 00 
  803086:	48 01 d0             	add    %rdx,%rax
  803089:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80308f:	c3                   	ret

0000000000803090 <__text_end>:
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
