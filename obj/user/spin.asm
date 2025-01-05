
obj/user/spin:     file format elf64-x86-64


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
  80001e:	e8 c6 00 00 00       	call   8000e9 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * Let it run for a couple time slices, then kill it. */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 08          	sub    $0x8,%rsp
    envid_t env;

    cprintf("I am the parent.  Forking the child...\n");
  800036:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80003d:	00 00 00 
  800040:	b8 00 00 00 00       	mov    $0x0,%eax
  800045:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  80004c:	00 00 00 
  80004f:	ff d2                	call   *%rdx
    if ((env = fork()) == 0) {
  800051:	48 b8 89 15 80 00 00 	movabs $0x801589,%rax
  800058:	00 00 00 
  80005b:	ff d0                	call   *%rax
  80005d:	85 c0                	test   %eax,%eax
  80005f:	75 1d                	jne    80007e <umain+0x59>
        cprintf("I am the child.  Spinning...\n");
  800061:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	call   *%rdx
        while (1) /* do nothing */
  80007c:	eb fe                	jmp    80007c <umain+0x57>
  80007e:	89 c3                	mov    %eax,%ebx
            ;
    }

    cprintf("I am the parent.  Running the child...\n");
  800080:	48 bf 28 40 80 00 00 	movabs $0x804028,%rdi
  800087:	00 00 00 
  80008a:	b8 00 00 00 00       	mov    $0x0,%eax
  80008f:	49 bd 77 02 80 00 00 	movabs $0x800277,%r13
  800096:	00 00 00 
  800099:	41 ff d5             	call   *%r13
    sys_yield();
  80009c:	49 bc 2a 11 80 00 00 	movabs $0x80112a,%r12
  8000a3:	00 00 00 
  8000a6:	41 ff d4             	call   *%r12
    sys_yield();
  8000a9:	41 ff d4             	call   *%r12
    sys_yield();
  8000ac:	41 ff d4             	call   *%r12
    sys_yield();
  8000af:	41 ff d4             	call   *%r12
    sys_yield();
  8000b2:	41 ff d4             	call   *%r12
    sys_yield();
  8000b5:	41 ff d4             	call   *%r12
    sys_yield();
  8000b8:	41 ff d4             	call   *%r12
    sys_yield();
  8000bb:	41 ff d4             	call   *%r12

    cprintf("I am the parent.  Killing the child...\n");
  8000be:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  8000c5:	00 00 00 
  8000c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cd:	41 ff d5             	call   *%r13
    sys_env_destroy(env);
  8000d0:	89 df                	mov    %ebx,%edi
  8000d2:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	call   *%rax
}
  8000de:	48 83 c4 08          	add    $0x8,%rsp
  8000e2:	5b                   	pop    %rbx
  8000e3:	41 5c                	pop    %r12
  8000e5:	41 5d                	pop    %r13
  8000e7:	5d                   	pop    %rbp
  8000e8:	c3                   	ret

00000000008000e9 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000e9:	f3 0f 1e fa          	endbr64
  8000ed:	55                   	push   %rbp
  8000ee:	48 89 e5             	mov    %rsp,%rbp
  8000f1:	41 56                	push   %r14
  8000f3:	41 55                	push   %r13
  8000f5:	41 54                	push   %r12
  8000f7:	53                   	push   %rbx
  8000f8:	41 89 fd             	mov    %edi,%r13d
  8000fb:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000fe:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800105:	00 00 00 
  800108:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80010f:	00 00 00 
  800112:	48 39 c2             	cmp    %rax,%rdx
  800115:	73 17                	jae    80012e <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800117:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80011a:	49 89 c4             	mov    %rax,%r12
  80011d:	48 83 c3 08          	add    $0x8,%rbx
  800121:	b8 00 00 00 00       	mov    $0x0,%eax
  800126:	ff 53 f8             	call   *-0x8(%rbx)
  800129:	4c 39 e3             	cmp    %r12,%rbx
  80012c:	72 ef                	jb     80011d <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80012e:	48 b8 f5 10 80 00 00 	movabs $0x8010f5,%rax
  800135:	00 00 00 
  800138:	ff d0                	call   *%rax
  80013a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800143:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800147:	48 c1 e0 04          	shl    $0x4,%rax
  80014b:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800152:	00 00 00 
  800155:	48 01 d0             	add    %rdx,%rax
  800158:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  80015f:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800162:	45 85 ed             	test   %r13d,%r13d
  800165:	7e 0d                	jle    800174 <libmain+0x8b>
  800167:	49 8b 06             	mov    (%r14),%rax
  80016a:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800171:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800174:	4c 89 f6             	mov    %r14,%rsi
  800177:	44 89 ef             	mov    %r13d,%edi
  80017a:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800181:	00 00 00 
  800184:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800186:	48 b8 9b 01 80 00 00 	movabs $0x80019b,%rax
  80018d:	00 00 00 
  800190:	ff d0                	call   *%rax
#endif
}
  800192:	5b                   	pop    %rbx
  800193:	41 5c                	pop    %r12
  800195:	41 5d                	pop    %r13
  800197:	41 5e                	pop    %r14
  800199:	5d                   	pop    %rbp
  80019a:	c3                   	ret

000000000080019b <exit>:

#include <inc/lib.h>

void
exit(void) {
  80019b:	f3 0f 1e fa          	endbr64
  80019f:	55                   	push   %rbp
  8001a0:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001a3:	48 b8 27 19 80 00 00 	movabs $0x801927,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001af:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b4:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  8001bb:	00 00 00 
  8001be:	ff d0                	call   *%rax
}
  8001c0:	5d                   	pop    %rbp
  8001c1:	c3                   	ret

00000000008001c2 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001c2:	f3 0f 1e fa          	endbr64
  8001c6:	55                   	push   %rbp
  8001c7:	48 89 e5             	mov    %rsp,%rbp
  8001ca:	53                   	push   %rbx
  8001cb:	48 83 ec 08          	sub    $0x8,%rsp
  8001cf:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001d2:	8b 06                	mov    (%rsi),%eax
  8001d4:	8d 50 01             	lea    0x1(%rax),%edx
  8001d7:	89 16                	mov    %edx,(%rsi)
  8001d9:	48 98                	cltq
  8001db:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8001e0:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8001e6:	74 0a                	je     8001f2 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8001e8:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8001ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001f0:	c9                   	leave
  8001f1:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8001f2:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8001f6:	be ff 00 00 00       	mov    $0xff,%esi
  8001fb:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  800202:	00 00 00 
  800205:	ff d0                	call   *%rax
        state->offset = 0;
  800207:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80020d:	eb d9                	jmp    8001e8 <putch+0x26>

000000000080020f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80020f:	f3 0f 1e fa          	endbr64
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80021e:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800221:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800228:	b9 21 00 00 00       	mov    $0x21,%ecx
  80022d:	b8 00 00 00 00       	mov    $0x0,%eax
  800232:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800235:	48 89 f1             	mov    %rsi,%rcx
  800238:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80023f:	48 bf c2 01 80 00 00 	movabs $0x8001c2,%rdi
  800246:	00 00 00 
  800249:	48 b8 d7 03 80 00 00 	movabs $0x8003d7,%rax
  800250:	00 00 00 
  800253:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800255:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80025c:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800263:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	call   *%rax

    return state.count;
}
  80026f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800275:	c9                   	leave
  800276:	c3                   	ret

0000000000800277 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800277:	f3 0f 1e fa          	endbr64
  80027b:	55                   	push   %rbp
  80027c:	48 89 e5             	mov    %rsp,%rbp
  80027f:	48 83 ec 50          	sub    $0x50,%rsp
  800283:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800287:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80028b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80028f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800293:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800297:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80029e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002a6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002aa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002ae:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002b2:	48 b8 0f 02 80 00 00 	movabs $0x80020f,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002be:	c9                   	leave
  8002bf:	c3                   	ret

00000000008002c0 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002c0:	f3 0f 1e fa          	endbr64
  8002c4:	55                   	push   %rbp
  8002c5:	48 89 e5             	mov    %rsp,%rbp
  8002c8:	41 57                	push   %r15
  8002ca:	41 56                	push   %r14
  8002cc:	41 55                	push   %r13
  8002ce:	41 54                	push   %r12
  8002d0:	53                   	push   %rbx
  8002d1:	48 83 ec 18          	sub    $0x18,%rsp
  8002d5:	49 89 fc             	mov    %rdi,%r12
  8002d8:	49 89 f5             	mov    %rsi,%r13
  8002db:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8002df:	8b 45 10             	mov    0x10(%rbp),%eax
  8002e2:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8002e5:	41 89 cf             	mov    %ecx,%r15d
  8002e8:	4c 39 fa             	cmp    %r15,%rdx
  8002eb:	73 5b                	jae    800348 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8002ed:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8002f1:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8002f5:	85 db                	test   %ebx,%ebx
  8002f7:	7e 0e                	jle    800307 <print_num+0x47>
            putch(padc, put_arg);
  8002f9:	4c 89 ee             	mov    %r13,%rsi
  8002fc:	44 89 f7             	mov    %r14d,%edi
  8002ff:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800302:	83 eb 01             	sub    $0x1,%ebx
  800305:	75 f2                	jne    8002f9 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800307:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80030b:	48 b9 b9 41 80 00 00 	movabs $0x8041b9,%rcx
  800312:	00 00 00 
  800315:	48 b8 a8 41 80 00 00 	movabs $0x8041a8,%rax
  80031c:	00 00 00 
  80031f:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800323:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800327:	ba 00 00 00 00       	mov    $0x0,%edx
  80032c:	49 f7 f7             	div    %r15
  80032f:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800333:	4c 89 ee             	mov    %r13,%rsi
  800336:	41 ff d4             	call   *%r12
}
  800339:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80033d:	5b                   	pop    %rbx
  80033e:	41 5c                	pop    %r12
  800340:	41 5d                	pop    %r13
  800342:	41 5e                	pop    %r14
  800344:	41 5f                	pop    %r15
  800346:	5d                   	pop    %rbp
  800347:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800348:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80034c:	ba 00 00 00 00       	mov    $0x0,%edx
  800351:	49 f7 f7             	div    %r15
  800354:	48 83 ec 08          	sub    $0x8,%rsp
  800358:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80035c:	52                   	push   %rdx
  80035d:	45 0f be c9          	movsbl %r9b,%r9d
  800361:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800365:	48 89 c2             	mov    %rax,%rdx
  800368:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  80036f:	00 00 00 
  800372:	ff d0                	call   *%rax
  800374:	48 83 c4 10          	add    $0x10,%rsp
  800378:	eb 8d                	jmp    800307 <print_num+0x47>

000000000080037a <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80037a:	f3 0f 1e fa          	endbr64
    state->count++;
  80037e:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800382:	48 8b 06             	mov    (%rsi),%rax
  800385:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800389:	73 0a                	jae    800395 <sprintputch+0x1b>
        *state->start++ = ch;
  80038b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80038f:	48 89 16             	mov    %rdx,(%rsi)
  800392:	40 88 38             	mov    %dil,(%rax)
    }
}
  800395:	c3                   	ret

0000000000800396 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800396:	f3 0f 1e fa          	endbr64
  80039a:	55                   	push   %rbp
  80039b:	48 89 e5             	mov    %rsp,%rbp
  80039e:	48 83 ec 50          	sub    $0x50,%rsp
  8003a2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003a6:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003aa:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003ae:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003bd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003c1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003c5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003c9:	48 b8 d7 03 80 00 00 	movabs $0x8003d7,%rax
  8003d0:	00 00 00 
  8003d3:	ff d0                	call   *%rax
}
  8003d5:	c9                   	leave
  8003d6:	c3                   	ret

00000000008003d7 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003d7:	f3 0f 1e fa          	endbr64
  8003db:	55                   	push   %rbp
  8003dc:	48 89 e5             	mov    %rsp,%rbp
  8003df:	41 57                	push   %r15
  8003e1:	41 56                	push   %r14
  8003e3:	41 55                	push   %r13
  8003e5:	41 54                	push   %r12
  8003e7:	53                   	push   %rbx
  8003e8:	48 83 ec 38          	sub    $0x38,%rsp
  8003ec:	49 89 fe             	mov    %rdi,%r14
  8003ef:	49 89 f5             	mov    %rsi,%r13
  8003f2:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8003f5:	48 8b 01             	mov    (%rcx),%rax
  8003f8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8003fc:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800400:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800404:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800408:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80040c:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800410:	0f b6 3b             	movzbl (%rbx),%edi
  800413:	40 80 ff 25          	cmp    $0x25,%dil
  800417:	74 18                	je     800431 <vprintfmt+0x5a>
            if (!ch) return;
  800419:	40 84 ff             	test   %dil,%dil
  80041c:	0f 84 b2 06 00 00    	je     800ad4 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800422:	40 0f b6 ff          	movzbl %dil,%edi
  800426:	4c 89 ee             	mov    %r13,%rsi
  800429:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80042c:	4c 89 e3             	mov    %r12,%rbx
  80042f:	eb db                	jmp    80040c <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800431:	be 00 00 00 00       	mov    $0x0,%esi
  800436:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80043f:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800445:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80044c:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800450:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800455:	41 0f b6 04 24       	movzbl (%r12),%eax
  80045a:	88 45 a0             	mov    %al,-0x60(%rbp)
  80045d:	83 e8 23             	sub    $0x23,%eax
  800460:	3c 57                	cmp    $0x57,%al
  800462:	0f 87 52 06 00 00    	ja     800aba <vprintfmt+0x6e3>
  800468:	0f b6 c0             	movzbl %al,%eax
  80046b:	48 b9 60 44 80 00 00 	movabs $0x804460,%rcx
  800472:	00 00 00 
  800475:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800479:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80047c:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800480:	eb ce                	jmp    800450 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800482:	49 89 dc             	mov    %rbx,%r12
  800485:	be 01 00 00 00       	mov    $0x1,%esi
  80048a:	eb c4                	jmp    800450 <vprintfmt+0x79>
            padc = ch;
  80048c:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800490:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800493:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800496:	eb b8                	jmp    800450 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800498:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80049b:	83 f8 2f             	cmp    $0x2f,%eax
  80049e:	77 24                	ja     8004c4 <vprintfmt+0xed>
  8004a0:	89 c1                	mov    %eax,%ecx
  8004a2:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8004a6:	83 c0 08             	add    $0x8,%eax
  8004a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004ac:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8004af:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8004b2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004b6:	79 98                	jns    800450 <vprintfmt+0x79>
                width = precision;
  8004b8:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8004bc:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004c2:	eb 8c                	jmp    800450 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8004c4:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8004c8:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8004cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d0:	eb da                	jmp    8004ac <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8004d2:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8004d7:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8004db:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8004e1:	3c 39                	cmp    $0x39,%al
  8004e3:	77 1c                	ja     800501 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8004e5:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8004e9:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8004ed:	0f b6 c0             	movzbl %al,%eax
  8004f0:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8004f5:	0f b6 03             	movzbl (%rbx),%eax
  8004f8:	3c 39                	cmp    $0x39,%al
  8004fa:	76 e9                	jbe    8004e5 <vprintfmt+0x10e>
        process_precision:
  8004fc:	49 89 dc             	mov    %rbx,%r12
  8004ff:	eb b1                	jmp    8004b2 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800501:	49 89 dc             	mov    %rbx,%r12
  800504:	eb ac                	jmp    8004b2 <vprintfmt+0xdb>
            width = MAX(0, width);
  800506:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800509:	85 c9                	test   %ecx,%ecx
  80050b:	b8 00 00 00 00       	mov    $0x0,%eax
  800510:	0f 49 c1             	cmovns %ecx,%eax
  800513:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800516:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800519:	e9 32 ff ff ff       	jmp    800450 <vprintfmt+0x79>
            lflag++;
  80051e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800521:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800524:	e9 27 ff ff ff       	jmp    800450 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800529:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80052c:	83 f8 2f             	cmp    $0x2f,%eax
  80052f:	77 19                	ja     80054a <vprintfmt+0x173>
  800531:	89 c2                	mov    %eax,%edx
  800533:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800537:	83 c0 08             	add    $0x8,%eax
  80053a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80053d:	8b 3a                	mov    (%rdx),%edi
  80053f:	4c 89 ee             	mov    %r13,%rsi
  800542:	41 ff d6             	call   *%r14
            break;
  800545:	e9 c2 fe ff ff       	jmp    80040c <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80054a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80054e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800552:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800556:	eb e5                	jmp    80053d <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800558:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80055b:	83 f8 2f             	cmp    $0x2f,%eax
  80055e:	77 5a                	ja     8005ba <vprintfmt+0x1e3>
  800560:	89 c2                	mov    %eax,%edx
  800562:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800566:	83 c0 08             	add    $0x8,%eax
  800569:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80056c:	8b 02                	mov    (%rdx),%eax
  80056e:	89 c1                	mov    %eax,%ecx
  800570:	f7 d9                	neg    %ecx
  800572:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800575:	83 f9 13             	cmp    $0x13,%ecx
  800578:	7f 4e                	jg     8005c8 <vprintfmt+0x1f1>
  80057a:	48 63 c1             	movslq %ecx,%rax
  80057d:	48 ba 20 47 80 00 00 	movabs $0x804720,%rdx
  800584:	00 00 00 
  800587:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80058b:	48 85 c0             	test   %rax,%rax
  80058e:	74 38                	je     8005c8 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800590:	48 89 c1             	mov    %rax,%rcx
  800593:	48 ba d3 43 80 00 00 	movabs $0x8043d3,%rdx
  80059a:	00 00 00 
  80059d:	4c 89 ee             	mov    %r13,%rsi
  8005a0:	4c 89 f7             	mov    %r14,%rdi
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	49 b8 96 03 80 00 00 	movabs $0x800396,%r8
  8005af:	00 00 00 
  8005b2:	41 ff d0             	call   *%r8
  8005b5:	e9 52 fe ff ff       	jmp    80040c <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8005ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005be:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c6:	eb a4                	jmp    80056c <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8005c8:	48 ba d1 41 80 00 00 	movabs $0x8041d1,%rdx
  8005cf:	00 00 00 
  8005d2:	4c 89 ee             	mov    %r13,%rsi
  8005d5:	4c 89 f7             	mov    %r14,%rdi
  8005d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005dd:	49 b8 96 03 80 00 00 	movabs $0x800396,%r8
  8005e4:	00 00 00 
  8005e7:	41 ff d0             	call   *%r8
  8005ea:	e9 1d fe ff ff       	jmp    80040c <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8005ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005f2:	83 f8 2f             	cmp    $0x2f,%eax
  8005f5:	77 6c                	ja     800663 <vprintfmt+0x28c>
  8005f7:	89 c2                	mov    %eax,%edx
  8005f9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005fd:	83 c0 08             	add    $0x8,%eax
  800600:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800603:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800606:	48 85 d2             	test   %rdx,%rdx
  800609:	48 b8 ca 41 80 00 00 	movabs $0x8041ca,%rax
  800610:	00 00 00 
  800613:	48 0f 45 c2          	cmovne %rdx,%rax
  800617:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80061b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80061f:	7e 06                	jle    800627 <vprintfmt+0x250>
  800621:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800625:	75 4a                	jne    800671 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800627:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80062b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80062f:	0f b6 00             	movzbl (%rax),%eax
  800632:	84 c0                	test   %al,%al
  800634:	0f 85 9a 00 00 00    	jne    8006d4 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80063a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80063d:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800641:	85 c0                	test   %eax,%eax
  800643:	0f 8e c3 fd ff ff    	jle    80040c <vprintfmt+0x35>
  800649:	4c 89 ee             	mov    %r13,%rsi
  80064c:	bf 20 00 00 00       	mov    $0x20,%edi
  800651:	41 ff d6             	call   *%r14
  800654:	41 83 ec 01          	sub    $0x1,%r12d
  800658:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80065c:	75 eb                	jne    800649 <vprintfmt+0x272>
  80065e:	e9 a9 fd ff ff       	jmp    80040c <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800663:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800667:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80066b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80066f:	eb 92                	jmp    800603 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800671:	49 63 f7             	movslq %r15d,%rsi
  800674:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800678:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  80067f:	00 00 00 
  800682:	ff d0                	call   *%rax
  800684:	48 89 c2             	mov    %rax,%rdx
  800687:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80068a:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80068c:	8d 70 ff             	lea    -0x1(%rax),%esi
  80068f:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800692:	85 c0                	test   %eax,%eax
  800694:	7e 91                	jle    800627 <vprintfmt+0x250>
  800696:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80069b:	4c 89 ee             	mov    %r13,%rsi
  80069e:	44 89 e7             	mov    %r12d,%edi
  8006a1:	41 ff d6             	call   *%r14
  8006a4:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006a8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006ab:	83 f8 ff             	cmp    $0xffffffff,%eax
  8006ae:	75 eb                	jne    80069b <vprintfmt+0x2c4>
  8006b0:	e9 72 ff ff ff       	jmp    800627 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006b5:	0f b6 f8             	movzbl %al,%edi
  8006b8:	4c 89 ee             	mov    %r13,%rsi
  8006bb:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006be:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006c2:	49 83 c4 01          	add    $0x1,%r12
  8006c6:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8006cc:	84 c0                	test   %al,%al
  8006ce:	0f 84 66 ff ff ff    	je     80063a <vprintfmt+0x263>
  8006d4:	45 85 ff             	test   %r15d,%r15d
  8006d7:	78 0a                	js     8006e3 <vprintfmt+0x30c>
  8006d9:	41 83 ef 01          	sub    $0x1,%r15d
  8006dd:	0f 88 57 ff ff ff    	js     80063a <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006e3:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8006e7:	74 cc                	je     8006b5 <vprintfmt+0x2de>
  8006e9:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006ec:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006f1:	80 fa 5e             	cmp    $0x5e,%dl
  8006f4:	77 c2                	ja     8006b8 <vprintfmt+0x2e1>
  8006f6:	eb bd                	jmp    8006b5 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8006f8:	40 84 f6             	test   %sil,%sil
  8006fb:	75 26                	jne    800723 <vprintfmt+0x34c>
    switch (lflag) {
  8006fd:	85 d2                	test   %edx,%edx
  8006ff:	74 59                	je     80075a <vprintfmt+0x383>
  800701:	83 fa 01             	cmp    $0x1,%edx
  800704:	74 7b                	je     800781 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800706:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800709:	83 f8 2f             	cmp    $0x2f,%eax
  80070c:	0f 87 96 00 00 00    	ja     8007a8 <vprintfmt+0x3d1>
  800712:	89 c2                	mov    %eax,%edx
  800714:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800718:	83 c0 08             	add    $0x8,%eax
  80071b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80071e:	4c 8b 22             	mov    (%rdx),%r12
  800721:	eb 17                	jmp    80073a <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800723:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800726:	83 f8 2f             	cmp    $0x2f,%eax
  800729:	77 21                	ja     80074c <vprintfmt+0x375>
  80072b:	89 c2                	mov    %eax,%edx
  80072d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800731:	83 c0 08             	add    $0x8,%eax
  800734:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800737:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80073a:	4d 85 e4             	test   %r12,%r12
  80073d:	78 7a                	js     8007b9 <vprintfmt+0x3e2>
            num = i;
  80073f:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800742:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800747:	e9 50 02 00 00       	jmp    80099c <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80074c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800750:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800754:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800758:	eb dd                	jmp    800737 <vprintfmt+0x360>
        return va_arg(*ap, int);
  80075a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075d:	83 f8 2f             	cmp    $0x2f,%eax
  800760:	77 11                	ja     800773 <vprintfmt+0x39c>
  800762:	89 c2                	mov    %eax,%edx
  800764:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800768:	83 c0 08             	add    $0x8,%eax
  80076b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80076e:	4c 63 22             	movslq (%rdx),%r12
  800771:	eb c7                	jmp    80073a <vprintfmt+0x363>
  800773:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800777:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80077b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80077f:	eb ed                	jmp    80076e <vprintfmt+0x397>
        return va_arg(*ap, long);
  800781:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800784:	83 f8 2f             	cmp    $0x2f,%eax
  800787:	77 11                	ja     80079a <vprintfmt+0x3c3>
  800789:	89 c2                	mov    %eax,%edx
  80078b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80078f:	83 c0 08             	add    $0x8,%eax
  800792:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800795:	4c 8b 22             	mov    (%rdx),%r12
  800798:	eb a0                	jmp    80073a <vprintfmt+0x363>
  80079a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80079e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a6:	eb ed                	jmp    800795 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8007a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007b0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007b4:	e9 65 ff ff ff       	jmp    80071e <vprintfmt+0x347>
                putch('-', put_arg);
  8007b9:	4c 89 ee             	mov    %r13,%rsi
  8007bc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007c1:	41 ff d6             	call   *%r14
                i = -i;
  8007c4:	49 f7 dc             	neg    %r12
  8007c7:	e9 73 ff ff ff       	jmp    80073f <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8007cc:	40 84 f6             	test   %sil,%sil
  8007cf:	75 32                	jne    800803 <vprintfmt+0x42c>
    switch (lflag) {
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	74 5d                	je     800832 <vprintfmt+0x45b>
  8007d5:	83 fa 01             	cmp    $0x1,%edx
  8007d8:	0f 84 82 00 00 00    	je     800860 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8007de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e1:	83 f8 2f             	cmp    $0x2f,%eax
  8007e4:	0f 87 a5 00 00 00    	ja     80088f <vprintfmt+0x4b8>
  8007ea:	89 c2                	mov    %eax,%edx
  8007ec:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007f0:	83 c0 08             	add    $0x8,%eax
  8007f3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f6:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8007f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8007fe:	e9 99 01 00 00       	jmp    80099c <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800803:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800806:	83 f8 2f             	cmp    $0x2f,%eax
  800809:	77 19                	ja     800824 <vprintfmt+0x44d>
  80080b:	89 c2                	mov    %eax,%edx
  80080d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800811:	83 c0 08             	add    $0x8,%eax
  800814:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800817:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80081a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80081f:	e9 78 01 00 00       	jmp    80099c <vprintfmt+0x5c5>
  800824:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800828:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80082c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800830:	eb e5                	jmp    800817 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800832:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800835:	83 f8 2f             	cmp    $0x2f,%eax
  800838:	77 18                	ja     800852 <vprintfmt+0x47b>
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800840:	83 c0 08             	add    $0x8,%eax
  800843:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800846:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800848:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80084d:	e9 4a 01 00 00       	jmp    80099c <vprintfmt+0x5c5>
  800852:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800856:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80085a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80085e:	eb e6                	jmp    800846 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800860:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800863:	83 f8 2f             	cmp    $0x2f,%eax
  800866:	77 19                	ja     800881 <vprintfmt+0x4aa>
  800868:	89 c2                	mov    %eax,%edx
  80086a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80086e:	83 c0 08             	add    $0x8,%eax
  800871:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800874:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800877:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80087c:	e9 1b 01 00 00       	jmp    80099c <vprintfmt+0x5c5>
  800881:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800885:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800889:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80088d:	eb e5                	jmp    800874 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80088f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800893:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800897:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80089b:	e9 56 ff ff ff       	jmp    8007f6 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8008a0:	40 84 f6             	test   %sil,%sil
  8008a3:	75 2e                	jne    8008d3 <vprintfmt+0x4fc>
    switch (lflag) {
  8008a5:	85 d2                	test   %edx,%edx
  8008a7:	74 59                	je     800902 <vprintfmt+0x52b>
  8008a9:	83 fa 01             	cmp    $0x1,%edx
  8008ac:	74 7f                	je     80092d <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8008ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b1:	83 f8 2f             	cmp    $0x2f,%eax
  8008b4:	0f 87 9f 00 00 00    	ja     800959 <vprintfmt+0x582>
  8008ba:	89 c2                	mov    %eax,%edx
  8008bc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c0:	83 c0 08             	add    $0x8,%eax
  8008c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c6:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008c9:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8008ce:	e9 c9 00 00 00       	jmp    80099c <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d6:	83 f8 2f             	cmp    $0x2f,%eax
  8008d9:	77 19                	ja     8008f4 <vprintfmt+0x51d>
  8008db:	89 c2                	mov    %eax,%edx
  8008dd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008e1:	83 c0 08             	add    $0x8,%eax
  8008e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e7:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008ea:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008ef:	e9 a8 00 00 00       	jmp    80099c <vprintfmt+0x5c5>
  8008f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800900:	eb e5                	jmp    8008e7 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800902:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800905:	83 f8 2f             	cmp    $0x2f,%eax
  800908:	77 15                	ja     80091f <vprintfmt+0x548>
  80090a:	89 c2                	mov    %eax,%edx
  80090c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800910:	83 c0 08             	add    $0x8,%eax
  800913:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800916:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800918:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80091d:	eb 7d                	jmp    80099c <vprintfmt+0x5c5>
  80091f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800923:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800927:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80092b:	eb e9                	jmp    800916 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  80092d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800930:	83 f8 2f             	cmp    $0x2f,%eax
  800933:	77 16                	ja     80094b <vprintfmt+0x574>
  800935:	89 c2                	mov    %eax,%edx
  800937:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80093b:	83 c0 08             	add    $0x8,%eax
  80093e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800941:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800944:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800949:	eb 51                	jmp    80099c <vprintfmt+0x5c5>
  80094b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800953:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800957:	eb e8                	jmp    800941 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800959:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800961:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800965:	e9 5c ff ff ff       	jmp    8008c6 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80096a:	4c 89 ee             	mov    %r13,%rsi
  80096d:	bf 30 00 00 00       	mov    $0x30,%edi
  800972:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800975:	4c 89 ee             	mov    %r13,%rsi
  800978:	bf 78 00 00 00       	mov    $0x78,%edi
  80097d:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800980:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800983:	83 f8 2f             	cmp    $0x2f,%eax
  800986:	77 47                	ja     8009cf <vprintfmt+0x5f8>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80098e:	83 c0 08             	add    $0x8,%eax
  800991:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800994:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800997:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80099c:	48 83 ec 08          	sub    $0x8,%rsp
  8009a0:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8009a4:	0f 94 c0             	sete   %al
  8009a7:	0f b6 c0             	movzbl %al,%eax
  8009aa:	50                   	push   %rax
  8009ab:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  8009b0:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009b4:	4c 89 ee             	mov    %r13,%rsi
  8009b7:	4c 89 f7             	mov    %r14,%rdi
  8009ba:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  8009c1:	00 00 00 
  8009c4:	ff d0                	call   *%rax
            break;
  8009c6:	48 83 c4 10          	add    $0x10,%rsp
  8009ca:	e9 3d fa ff ff       	jmp    80040c <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8009cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009db:	eb b7                	jmp    800994 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8009dd:	40 84 f6             	test   %sil,%sil
  8009e0:	75 2b                	jne    800a0d <vprintfmt+0x636>
    switch (lflag) {
  8009e2:	85 d2                	test   %edx,%edx
  8009e4:	74 56                	je     800a3c <vprintfmt+0x665>
  8009e6:	83 fa 01             	cmp    $0x1,%edx
  8009e9:	74 7f                	je     800a6a <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8009eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ee:	83 f8 2f             	cmp    $0x2f,%eax
  8009f1:	0f 87 a2 00 00 00    	ja     800a99 <vprintfmt+0x6c2>
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009fd:	83 c0 08             	add    $0x8,%eax
  800a00:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a03:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a06:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a0b:	eb 8f                	jmp    80099c <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a10:	83 f8 2f             	cmp    $0x2f,%eax
  800a13:	77 19                	ja     800a2e <vprintfmt+0x657>
  800a15:	89 c2                	mov    %eax,%edx
  800a17:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a1b:	83 c0 08             	add    $0x8,%eax
  800a1e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a21:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a24:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a29:	e9 6e ff ff ff       	jmp    80099c <vprintfmt+0x5c5>
  800a2e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a32:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a36:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3a:	eb e5                	jmp    800a21 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800a3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3f:	83 f8 2f             	cmp    $0x2f,%eax
  800a42:	77 18                	ja     800a5c <vprintfmt+0x685>
  800a44:	89 c2                	mov    %eax,%edx
  800a46:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4a:	83 c0 08             	add    $0x8,%eax
  800a4d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a50:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800a52:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a57:	e9 40 ff ff ff       	jmp    80099c <vprintfmt+0x5c5>
  800a5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a60:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a68:	eb e6                	jmp    800a50 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800a6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6d:	83 f8 2f             	cmp    $0x2f,%eax
  800a70:	77 19                	ja     800a8b <vprintfmt+0x6b4>
  800a72:	89 c2                	mov    %eax,%edx
  800a74:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a78:	83 c0 08             	add    $0x8,%eax
  800a7b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a7e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a81:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a86:	e9 11 ff ff ff       	jmp    80099c <vprintfmt+0x5c5>
  800a8b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a93:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a97:	eb e5                	jmp    800a7e <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800a99:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a9d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aa1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa5:	e9 59 ff ff ff       	jmp    800a03 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800aaa:	4c 89 ee             	mov    %r13,%rsi
  800aad:	bf 25 00 00 00       	mov    $0x25,%edi
  800ab2:	41 ff d6             	call   *%r14
            break;
  800ab5:	e9 52 f9 ff ff       	jmp    80040c <vprintfmt+0x35>
            putch('%', put_arg);
  800aba:	4c 89 ee             	mov    %r13,%rsi
  800abd:	bf 25 00 00 00       	mov    $0x25,%edi
  800ac2:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800ac5:	48 83 eb 01          	sub    $0x1,%rbx
  800ac9:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800acd:	75 f6                	jne    800ac5 <vprintfmt+0x6ee>
  800acf:	e9 38 f9 ff ff       	jmp    80040c <vprintfmt+0x35>
}
  800ad4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ad8:	5b                   	pop    %rbx
  800ad9:	41 5c                	pop    %r12
  800adb:	41 5d                	pop    %r13
  800add:	41 5e                	pop    %r14
  800adf:	41 5f                	pop    %r15
  800ae1:	5d                   	pop    %rbp
  800ae2:	c3                   	ret

0000000000800ae3 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800ae3:	f3 0f 1e fa          	endbr64
  800ae7:	55                   	push   %rbp
  800ae8:	48 89 e5             	mov    %rsp,%rbp
  800aeb:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800aef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800af3:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800af8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800afc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b03:	48 85 ff             	test   %rdi,%rdi
  800b06:	74 2b                	je     800b33 <vsnprintf+0x50>
  800b08:	48 85 f6             	test   %rsi,%rsi
  800b0b:	74 26                	je     800b33 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b0d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b11:	48 bf 7a 03 80 00 00 	movabs $0x80037a,%rdi
  800b18:	00 00 00 
  800b1b:	48 b8 d7 03 80 00 00 	movabs $0x8003d7,%rax
  800b22:	00 00 00 
  800b25:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2b:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b31:	c9                   	leave
  800b32:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800b33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b38:	eb f7                	jmp    800b31 <vsnprintf+0x4e>

0000000000800b3a <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b3a:	f3 0f 1e fa          	endbr64
  800b3e:	55                   	push   %rbp
  800b3f:	48 89 e5             	mov    %rsp,%rbp
  800b42:	48 83 ec 50          	sub    $0x50,%rsp
  800b46:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b4a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b4e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b52:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b59:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b5d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b61:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b65:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b69:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b6d:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  800b74:	00 00 00 
  800b77:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b79:	c9                   	leave
  800b7a:	c3                   	ret

0000000000800b7b <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800b7b:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800b7f:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b82:	74 10                	je     800b94 <strlen+0x19>
    size_t n = 0;
  800b84:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b89:	48 83 c0 01          	add    $0x1,%rax
  800b8d:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b91:	75 f6                	jne    800b89 <strlen+0xe>
  800b93:	c3                   	ret
    size_t n = 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b99:	c3                   	ret

0000000000800b9a <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800b9a:	f3 0f 1e fa          	endbr64
  800b9e:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800ba1:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800ba6:	48 85 f6             	test   %rsi,%rsi
  800ba9:	74 10                	je     800bbb <strnlen+0x21>
  800bab:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800baf:	74 0b                	je     800bbc <strnlen+0x22>
  800bb1:	48 83 c2 01          	add    $0x1,%rdx
  800bb5:	48 39 d0             	cmp    %rdx,%rax
  800bb8:	75 f1                	jne    800bab <strnlen+0x11>
  800bba:	c3                   	ret
  800bbb:	c3                   	ret
  800bbc:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800bbf:	c3                   	ret

0000000000800bc0 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800bc0:	f3 0f 1e fa          	endbr64
  800bc4:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcc:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800bd0:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800bd3:	48 83 c2 01          	add    $0x1,%rdx
  800bd7:	84 c9                	test   %cl,%cl
  800bd9:	75 f1                	jne    800bcc <strcpy+0xc>
        ;
    return res;
}
  800bdb:	c3                   	ret

0000000000800bdc <strcat>:

char *
strcat(char *dst, const char *src) {
  800bdc:	f3 0f 1e fa          	endbr64
  800be0:	55                   	push   %rbp
  800be1:	48 89 e5             	mov    %rsp,%rbp
  800be4:	41 54                	push   %r12
  800be6:	53                   	push   %rbx
  800be7:	48 89 fb             	mov    %rdi,%rbx
  800bea:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800bed:	48 b8 7b 0b 80 00 00 	movabs $0x800b7b,%rax
  800bf4:	00 00 00 
  800bf7:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800bf9:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800bfd:	4c 89 e6             	mov    %r12,%rsi
  800c00:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  800c07:	00 00 00 
  800c0a:	ff d0                	call   *%rax
    return dst;
}
  800c0c:	48 89 d8             	mov    %rbx,%rax
  800c0f:	5b                   	pop    %rbx
  800c10:	41 5c                	pop    %r12
  800c12:	5d                   	pop    %rbp
  800c13:	c3                   	ret

0000000000800c14 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c14:	f3 0f 1e fa          	endbr64
  800c18:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c1b:	48 85 d2             	test   %rdx,%rdx
  800c1e:	74 1f                	je     800c3f <strncpy+0x2b>
  800c20:	48 01 fa             	add    %rdi,%rdx
  800c23:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800c26:	48 83 c1 01          	add    $0x1,%rcx
  800c2a:	44 0f b6 06          	movzbl (%rsi),%r8d
  800c2e:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c32:	41 80 f8 01          	cmp    $0x1,%r8b
  800c36:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c3a:	48 39 ca             	cmp    %rcx,%rdx
  800c3d:	75 e7                	jne    800c26 <strncpy+0x12>
    }
    return ret;
}
  800c3f:	c3                   	ret

0000000000800c40 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800c40:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800c44:	48 89 f8             	mov    %rdi,%rax
  800c47:	48 85 d2             	test   %rdx,%rdx
  800c4a:	74 24                	je     800c70 <strlcpy+0x30>
        while (--size > 0 && *src)
  800c4c:	48 83 ea 01          	sub    $0x1,%rdx
  800c50:	74 1b                	je     800c6d <strlcpy+0x2d>
  800c52:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c56:	0f b6 16             	movzbl (%rsi),%edx
  800c59:	84 d2                	test   %dl,%dl
  800c5b:	74 10                	je     800c6d <strlcpy+0x2d>
            *dst++ = *src++;
  800c5d:	48 83 c6 01          	add    $0x1,%rsi
  800c61:	48 83 c0 01          	add    $0x1,%rax
  800c65:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c68:	48 39 c8             	cmp    %rcx,%rax
  800c6b:	75 e9                	jne    800c56 <strlcpy+0x16>
        *dst = '\0';
  800c6d:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c70:	48 29 f8             	sub    %rdi,%rax
}
  800c73:	c3                   	ret

0000000000800c74 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800c74:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800c78:	0f b6 07             	movzbl (%rdi),%eax
  800c7b:	84 c0                	test   %al,%al
  800c7d:	74 13                	je     800c92 <strcmp+0x1e>
  800c7f:	38 06                	cmp    %al,(%rsi)
  800c81:	75 0f                	jne    800c92 <strcmp+0x1e>
  800c83:	48 83 c7 01          	add    $0x1,%rdi
  800c87:	48 83 c6 01          	add    $0x1,%rsi
  800c8b:	0f b6 07             	movzbl (%rdi),%eax
  800c8e:	84 c0                	test   %al,%al
  800c90:	75 ed                	jne    800c7f <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c92:	0f b6 c0             	movzbl %al,%eax
  800c95:	0f b6 16             	movzbl (%rsi),%edx
  800c98:	29 d0                	sub    %edx,%eax
}
  800c9a:	c3                   	ret

0000000000800c9b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800c9b:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800c9f:	48 85 d2             	test   %rdx,%rdx
  800ca2:	74 1f                	je     800cc3 <strncmp+0x28>
  800ca4:	0f b6 07             	movzbl (%rdi),%eax
  800ca7:	84 c0                	test   %al,%al
  800ca9:	74 1e                	je     800cc9 <strncmp+0x2e>
  800cab:	3a 06                	cmp    (%rsi),%al
  800cad:	75 1a                	jne    800cc9 <strncmp+0x2e>
  800caf:	48 83 c7 01          	add    $0x1,%rdi
  800cb3:	48 83 c6 01          	add    $0x1,%rsi
  800cb7:	48 83 ea 01          	sub    $0x1,%rdx
  800cbb:	75 e7                	jne    800ca4 <strncmp+0x9>

    if (!n) return 0;
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	c3                   	ret
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc8:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800cc9:	0f b6 07             	movzbl (%rdi),%eax
  800ccc:	0f b6 16             	movzbl (%rsi),%edx
  800ccf:	29 d0                	sub    %edx,%eax
}
  800cd1:	c3                   	ret

0000000000800cd2 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800cd2:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800cd6:	0f b6 17             	movzbl (%rdi),%edx
  800cd9:	84 d2                	test   %dl,%dl
  800cdb:	74 18                	je     800cf5 <strchr+0x23>
        if (*str == c) {
  800cdd:	0f be d2             	movsbl %dl,%edx
  800ce0:	39 f2                	cmp    %esi,%edx
  800ce2:	74 17                	je     800cfb <strchr+0x29>
    for (; *str; str++) {
  800ce4:	48 83 c7 01          	add    $0x1,%rdi
  800ce8:	0f b6 17             	movzbl (%rdi),%edx
  800ceb:	84 d2                	test   %dl,%dl
  800ced:	75 ee                	jne    800cdd <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	c3                   	ret
  800cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfa:	c3                   	ret
            return (char *)str;
  800cfb:	48 89 f8             	mov    %rdi,%rax
}
  800cfe:	c3                   	ret

0000000000800cff <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800cff:	f3 0f 1e fa          	endbr64
  800d03:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d06:	0f b6 17             	movzbl (%rdi),%edx
  800d09:	84 d2                	test   %dl,%dl
  800d0b:	74 13                	je     800d20 <strfind+0x21>
  800d0d:	0f be d2             	movsbl %dl,%edx
  800d10:	39 f2                	cmp    %esi,%edx
  800d12:	74 0b                	je     800d1f <strfind+0x20>
  800d14:	48 83 c0 01          	add    $0x1,%rax
  800d18:	0f b6 10             	movzbl (%rax),%edx
  800d1b:	84 d2                	test   %dl,%dl
  800d1d:	75 ee                	jne    800d0d <strfind+0xe>
        ;
    return (char *)str;
}
  800d1f:	c3                   	ret
  800d20:	c3                   	ret

0000000000800d21 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d21:	f3 0f 1e fa          	endbr64
  800d25:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d28:	48 89 f8             	mov    %rdi,%rax
  800d2b:	48 f7 d8             	neg    %rax
  800d2e:	83 e0 07             	and    $0x7,%eax
  800d31:	49 89 d1             	mov    %rdx,%r9
  800d34:	49 29 c1             	sub    %rax,%r9
  800d37:	78 36                	js     800d6f <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d39:	40 0f b6 c6          	movzbl %sil,%eax
  800d3d:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800d44:	01 01 01 
  800d47:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d4b:	40 f6 c7 07          	test   $0x7,%dil
  800d4f:	75 38                	jne    800d89 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d51:	4c 89 c9             	mov    %r9,%rcx
  800d54:	48 c1 f9 03          	sar    $0x3,%rcx
  800d58:	74 0c                	je     800d66 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d5a:	fc                   	cld
  800d5b:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d5e:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800d62:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d66:	4d 85 c9             	test   %r9,%r9
  800d69:	75 45                	jne    800db0 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d6b:	4c 89 c0             	mov    %r8,%rax
  800d6e:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800d6f:	48 85 d2             	test   %rdx,%rdx
  800d72:	74 f7                	je     800d6b <memset+0x4a>
  800d74:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d77:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d7a:	48 83 c0 01          	add    $0x1,%rax
  800d7e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d82:	48 39 c2             	cmp    %rax,%rdx
  800d85:	75 f3                	jne    800d7a <memset+0x59>
  800d87:	eb e2                	jmp    800d6b <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d89:	40 f6 c7 01          	test   $0x1,%dil
  800d8d:	74 06                	je     800d95 <memset+0x74>
  800d8f:	88 07                	mov    %al,(%rdi)
  800d91:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d95:	40 f6 c7 02          	test   $0x2,%dil
  800d99:	74 07                	je     800da2 <memset+0x81>
  800d9b:	66 89 07             	mov    %ax,(%rdi)
  800d9e:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800da2:	40 f6 c7 04          	test   $0x4,%dil
  800da6:	74 a9                	je     800d51 <memset+0x30>
  800da8:	89 07                	mov    %eax,(%rdi)
  800daa:	48 83 c7 04          	add    $0x4,%rdi
  800dae:	eb a1                	jmp    800d51 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800db0:	41 f6 c1 04          	test   $0x4,%r9b
  800db4:	74 1b                	je     800dd1 <memset+0xb0>
  800db6:	89 07                	mov    %eax,(%rdi)
  800db8:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dbc:	41 f6 c1 02          	test   $0x2,%r9b
  800dc0:	74 07                	je     800dc9 <memset+0xa8>
  800dc2:	66 89 07             	mov    %ax,(%rdi)
  800dc5:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800dc9:	41 f6 c1 01          	test   $0x1,%r9b
  800dcd:	74 9c                	je     800d6b <memset+0x4a>
  800dcf:	eb 06                	jmp    800dd7 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dd1:	41 f6 c1 02          	test   $0x2,%r9b
  800dd5:	75 eb                	jne    800dc2 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800dd7:	88 07                	mov    %al,(%rdi)
  800dd9:	eb 90                	jmp    800d6b <memset+0x4a>

0000000000800ddb <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ddb:	f3 0f 1e fa          	endbr64
  800ddf:	48 89 f8             	mov    %rdi,%rax
  800de2:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800de5:	48 39 fe             	cmp    %rdi,%rsi
  800de8:	73 3b                	jae    800e25 <memmove+0x4a>
  800dea:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800dee:	48 39 d7             	cmp    %rdx,%rdi
  800df1:	73 32                	jae    800e25 <memmove+0x4a>
        s += n;
        d += n;
  800df3:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800df7:	48 89 d6             	mov    %rdx,%rsi
  800dfa:	48 09 fe             	or     %rdi,%rsi
  800dfd:	48 09 ce             	or     %rcx,%rsi
  800e00:	40 f6 c6 07          	test   $0x7,%sil
  800e04:	75 12                	jne    800e18 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e06:	48 83 ef 08          	sub    $0x8,%rdi
  800e0a:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e0e:	48 c1 e9 03          	shr    $0x3,%rcx
  800e12:	fd                   	std
  800e13:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e16:	fc                   	cld
  800e17:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e18:	48 83 ef 01          	sub    $0x1,%rdi
  800e1c:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e20:	fd                   	std
  800e21:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e23:	eb f1                	jmp    800e16 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e25:	48 89 f2             	mov    %rsi,%rdx
  800e28:	48 09 c2             	or     %rax,%rdx
  800e2b:	48 09 ca             	or     %rcx,%rdx
  800e2e:	f6 c2 07             	test   $0x7,%dl
  800e31:	75 0c                	jne    800e3f <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e33:	48 c1 e9 03          	shr    $0x3,%rcx
  800e37:	48 89 c7             	mov    %rax,%rdi
  800e3a:	fc                   	cld
  800e3b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e3e:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e3f:	48 89 c7             	mov    %rax,%rdi
  800e42:	fc                   	cld
  800e43:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e45:	c3                   	ret

0000000000800e46 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e46:	f3 0f 1e fa          	endbr64
  800e4a:	55                   	push   %rbp
  800e4b:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e4e:	48 b8 db 0d 80 00 00 	movabs $0x800ddb,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	call   *%rax
}
  800e5a:	5d                   	pop    %rbp
  800e5b:	c3                   	ret

0000000000800e5c <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e5c:	f3 0f 1e fa          	endbr64
  800e60:	55                   	push   %rbp
  800e61:	48 89 e5             	mov    %rsp,%rbp
  800e64:	41 57                	push   %r15
  800e66:	41 56                	push   %r14
  800e68:	41 55                	push   %r13
  800e6a:	41 54                	push   %r12
  800e6c:	53                   	push   %rbx
  800e6d:	48 83 ec 08          	sub    $0x8,%rsp
  800e71:	49 89 fe             	mov    %rdi,%r14
  800e74:	49 89 f7             	mov    %rsi,%r15
  800e77:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e7a:	48 89 f7             	mov    %rsi,%rdi
  800e7d:	48 b8 7b 0b 80 00 00 	movabs $0x800b7b,%rax
  800e84:	00 00 00 
  800e87:	ff d0                	call   *%rax
  800e89:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e8c:	48 89 de             	mov    %rbx,%rsi
  800e8f:	4c 89 f7             	mov    %r14,%rdi
  800e92:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	call   *%rax
  800e9e:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ea1:	48 39 c3             	cmp    %rax,%rbx
  800ea4:	74 36                	je     800edc <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800ea6:	48 89 d8             	mov    %rbx,%rax
  800ea9:	4c 29 e8             	sub    %r13,%rax
  800eac:	49 39 c4             	cmp    %rax,%r12
  800eaf:	73 31                	jae    800ee2 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800eb1:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800eb6:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800eba:	4c 89 fe             	mov    %r15,%rsi
  800ebd:	48 b8 46 0e 80 00 00 	movabs $0x800e46,%rax
  800ec4:	00 00 00 
  800ec7:	ff d0                	call   *%rax
    return dstlen + srclen;
  800ec9:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800ecd:	48 83 c4 08          	add    $0x8,%rsp
  800ed1:	5b                   	pop    %rbx
  800ed2:	41 5c                	pop    %r12
  800ed4:	41 5d                	pop    %r13
  800ed6:	41 5e                	pop    %r14
  800ed8:	41 5f                	pop    %r15
  800eda:	5d                   	pop    %rbp
  800edb:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800edc:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800ee0:	eb eb                	jmp    800ecd <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ee2:	48 83 eb 01          	sub    $0x1,%rbx
  800ee6:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800eea:	48 89 da             	mov    %rbx,%rdx
  800eed:	4c 89 fe             	mov    %r15,%rsi
  800ef0:	48 b8 46 0e 80 00 00 	movabs $0x800e46,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800efc:	49 01 de             	add    %rbx,%r14
  800eff:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f04:	eb c3                	jmp    800ec9 <strlcat+0x6d>

0000000000800f06 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f06:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f0a:	48 85 d2             	test   %rdx,%rdx
  800f0d:	74 2d                	je     800f3c <memcmp+0x36>
  800f0f:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f14:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f18:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f1d:	44 38 c1             	cmp    %r8b,%cl
  800f20:	75 0f                	jne    800f31 <memcmp+0x2b>
    while (n-- > 0) {
  800f22:	48 83 c0 01          	add    $0x1,%rax
  800f26:	48 39 c2             	cmp    %rax,%rdx
  800f29:	75 e9                	jne    800f14 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f30:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800f31:	0f b6 c1             	movzbl %cl,%eax
  800f34:	45 0f b6 c0          	movzbl %r8b,%r8d
  800f38:	44 29 c0             	sub    %r8d,%eax
  800f3b:	c3                   	ret
    return 0;
  800f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f41:	c3                   	ret

0000000000800f42 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800f42:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800f46:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f4a:	48 39 c7             	cmp    %rax,%rdi
  800f4d:	73 0f                	jae    800f5e <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f4f:	40 38 37             	cmp    %sil,(%rdi)
  800f52:	74 0e                	je     800f62 <memfind+0x20>
    for (; src < end; src++) {
  800f54:	48 83 c7 01          	add    $0x1,%rdi
  800f58:	48 39 f8             	cmp    %rdi,%rax
  800f5b:	75 f2                	jne    800f4f <memfind+0xd>
  800f5d:	c3                   	ret
  800f5e:	48 89 f8             	mov    %rdi,%rax
  800f61:	c3                   	ret
  800f62:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f65:	c3                   	ret

0000000000800f66 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f66:	f3 0f 1e fa          	endbr64
  800f6a:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f6d:	0f b6 37             	movzbl (%rdi),%esi
  800f70:	40 80 fe 20          	cmp    $0x20,%sil
  800f74:	74 06                	je     800f7c <strtol+0x16>
  800f76:	40 80 fe 09          	cmp    $0x9,%sil
  800f7a:	75 13                	jne    800f8f <strtol+0x29>
  800f7c:	48 83 c7 01          	add    $0x1,%rdi
  800f80:	0f b6 37             	movzbl (%rdi),%esi
  800f83:	40 80 fe 20          	cmp    $0x20,%sil
  800f87:	74 f3                	je     800f7c <strtol+0x16>
  800f89:	40 80 fe 09          	cmp    $0x9,%sil
  800f8d:	74 ed                	je     800f7c <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f8f:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f92:	83 e0 fd             	and    $0xfffffffd,%eax
  800f95:	3c 01                	cmp    $0x1,%al
  800f97:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f9b:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800fa1:	75 0f                	jne    800fb2 <strtol+0x4c>
  800fa3:	80 3f 30             	cmpb   $0x30,(%rdi)
  800fa6:	74 14                	je     800fbc <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fa8:	85 d2                	test   %edx,%edx
  800faa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800faf:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800fb2:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800fb7:	4c 63 ca             	movslq %edx,%r9
  800fba:	eb 36                	jmp    800ff2 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fbc:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800fc0:	74 0f                	je     800fd1 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800fc2:	85 d2                	test   %edx,%edx
  800fc4:	75 ec                	jne    800fb2 <strtol+0x4c>
        s++;
  800fc6:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800fca:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800fcf:	eb e1                	jmp    800fb2 <strtol+0x4c>
        s += 2;
  800fd1:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800fd5:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800fda:	eb d6                	jmp    800fb2 <strtol+0x4c>
            dig -= '0';
  800fdc:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800fdf:	44 0f b6 c1          	movzbl %cl,%r8d
  800fe3:	41 39 d0             	cmp    %edx,%r8d
  800fe6:	7d 21                	jge    801009 <strtol+0xa3>
        val = val * base + dig;
  800fe8:	49 0f af c1          	imul   %r9,%rax
  800fec:	0f b6 c9             	movzbl %cl,%ecx
  800fef:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800ff2:	48 83 c7 01          	add    $0x1,%rdi
  800ff6:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  800ffa:	80 f9 39             	cmp    $0x39,%cl
  800ffd:	76 dd                	jbe    800fdc <strtol+0x76>
        else if (dig - 'a' < 27)
  800fff:	80 f9 7b             	cmp    $0x7b,%cl
  801002:	77 05                	ja     801009 <strtol+0xa3>
            dig -= 'a' - 10;
  801004:	83 e9 57             	sub    $0x57,%ecx
  801007:	eb d6                	jmp    800fdf <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801009:	4d 85 d2             	test   %r10,%r10
  80100c:	74 03                	je     801011 <strtol+0xab>
  80100e:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801011:	48 89 c2             	mov    %rax,%rdx
  801014:	48 f7 da             	neg    %rdx
  801017:	40 80 fe 2d          	cmp    $0x2d,%sil
  80101b:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80101f:	c3                   	ret

0000000000801020 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801020:	f3 0f 1e fa          	endbr64
  801024:	55                   	push   %rbp
  801025:	48 89 e5             	mov    %rsp,%rbp
  801028:	53                   	push   %rbx
  801029:	48 89 fa             	mov    %rdi,%rdx
  80102c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801034:	bb 00 00 00 00       	mov    $0x0,%ebx
  801039:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80103e:	be 00 00 00 00       	mov    $0x0,%esi
  801043:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801049:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80104b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80104f:	c9                   	leave
  801050:	c3                   	ret

0000000000801051 <sys_cgetc>:

int
sys_cgetc(void) {
  801051:	f3 0f 1e fa          	endbr64
  801055:	55                   	push   %rbp
  801056:	48 89 e5             	mov    %rsp,%rbp
  801059:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80105a:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80105f:	ba 00 00 00 00       	mov    $0x0,%edx
  801064:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801073:	be 00 00 00 00       	mov    $0x0,%esi
  801078:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80107e:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801080:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801084:	c9                   	leave
  801085:	c3                   	ret

0000000000801086 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801086:	f3 0f 1e fa          	endbr64
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	53                   	push   %rbx
  80108f:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801093:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801096:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80109b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010aa:	be 00 00 00 00       	mov    $0x0,%esi
  8010af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010b5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010b7:	48 85 c0             	test   %rax,%rax
  8010ba:	7f 06                	jg     8010c2 <sys_env_destroy+0x3c>
}
  8010bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c0:	c9                   	leave
  8010c1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010c2:	49 89 c0             	mov    %rax,%r8
  8010c5:	b9 03 00 00 00       	mov    $0x3,%ecx
  8010ca:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  8010d1:	00 00 00 
  8010d4:	be 26 00 00 00       	mov    $0x26,%esi
  8010d9:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  8010e0:	00 00 00 
  8010e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e8:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  8010ef:	00 00 00 
  8010f2:	41 ff d1             	call   *%r9

00000000008010f5 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8010f5:	f3 0f 1e fa          	endbr64
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010fe:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801103:	ba 00 00 00 00       	mov    $0x0,%edx
  801108:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80110d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801112:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801117:	be 00 00 00 00       	mov    $0x0,%esi
  80111c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801122:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801124:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801128:	c9                   	leave
  801129:	c3                   	ret

000000000080112a <sys_yield>:

void
sys_yield(void) {
  80112a:	f3 0f 1e fa          	endbr64
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801133:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801138:	ba 00 00 00 00       	mov    $0x0,%edx
  80113d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801142:	bb 00 00 00 00       	mov    $0x0,%ebx
  801147:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114c:	be 00 00 00 00       	mov    $0x0,%esi
  801151:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801157:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801159:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80115d:	c9                   	leave
  80115e:	c3                   	ret

000000000080115f <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80115f:	f3 0f 1e fa          	endbr64
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	53                   	push   %rbx
  801168:	48 89 fa             	mov    %rdi,%rdx
  80116b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80116e:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801173:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80117a:	00 00 00 
  80117d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801182:	be 00 00 00 00       	mov    $0x0,%esi
  801187:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80118d:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80118f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801193:	c9                   	leave
  801194:	c3                   	ret

0000000000801195 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801195:	f3 0f 1e fa          	endbr64
  801199:	55                   	push   %rbp
  80119a:	48 89 e5             	mov    %rsp,%rbp
  80119d:	53                   	push   %rbx
  80119e:	49 89 f8             	mov    %rdi,%r8
  8011a1:	48 89 d3             	mov    %rdx,%rbx
  8011a4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011a7:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ac:	4c 89 c2             	mov    %r8,%rdx
  8011af:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b2:	be 00 00 00 00       	mov    $0x0,%esi
  8011b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011bd:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8011bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c3:	c9                   	leave
  8011c4:	c3                   	ret

00000000008011c5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8011c5:	f3 0f 1e fa          	endbr64
  8011c9:	55                   	push   %rbp
  8011ca:	48 89 e5             	mov    %rsp,%rbp
  8011cd:	53                   	push   %rbx
  8011ce:	48 83 ec 08          	sub    $0x8,%rsp
  8011d2:	89 f8                	mov    %edi,%eax
  8011d4:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011d7:	48 63 f9             	movslq %ecx,%rdi
  8011da:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011dd:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011e2:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e5:	be 00 00 00 00       	mov    $0x0,%esi
  8011ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011f2:	48 85 c0             	test   %rax,%rax
  8011f5:	7f 06                	jg     8011fd <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011f7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011fb:	c9                   	leave
  8011fc:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011fd:	49 89 c0             	mov    %rax,%r8
  801200:	b9 04 00 00 00       	mov    $0x4,%ecx
  801205:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  80120c:	00 00 00 
  80120f:	be 26 00 00 00       	mov    $0x26,%esi
  801214:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  80121b:	00 00 00 
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
  801223:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  80122a:	00 00 00 
  80122d:	41 ff d1             	call   *%r9

0000000000801230 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801230:	f3 0f 1e fa          	endbr64
  801234:	55                   	push   %rbp
  801235:	48 89 e5             	mov    %rsp,%rbp
  801238:	53                   	push   %rbx
  801239:	48 83 ec 08          	sub    $0x8,%rsp
  80123d:	89 f8                	mov    %edi,%eax
  80123f:	49 89 f2             	mov    %rsi,%r10
  801242:	48 89 cf             	mov    %rcx,%rdi
  801245:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801248:	48 63 da             	movslq %edx,%rbx
  80124b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80124e:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801253:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801256:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801259:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80125b:	48 85 c0             	test   %rax,%rax
  80125e:	7f 06                	jg     801266 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801260:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801264:	c9                   	leave
  801265:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801266:	49 89 c0             	mov    %rax,%r8
  801269:	b9 05 00 00 00       	mov    $0x5,%ecx
  80126e:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  801275:	00 00 00 
  801278:	be 26 00 00 00       	mov    $0x26,%esi
  80127d:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  801284:	00 00 00 
  801287:	b8 00 00 00 00       	mov    $0x0,%eax
  80128c:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  801293:	00 00 00 
  801296:	41 ff d1             	call   *%r9

0000000000801299 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801299:	f3 0f 1e fa          	endbr64
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	53                   	push   %rbx
  8012a2:	48 83 ec 08          	sub    $0x8,%rsp
  8012a6:	49 89 f9             	mov    %rdi,%r9
  8012a9:	89 f0                	mov    %esi,%eax
  8012ab:	48 89 d3             	mov    %rdx,%rbx
  8012ae:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8012b1:	49 63 f0             	movslq %r8d,%rsi
  8012b4:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012b7:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012bc:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012c7:	48 85 c0             	test   %rax,%rax
  8012ca:	7f 06                	jg     8012d2 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012d0:	c9                   	leave
  8012d1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012d2:	49 89 c0             	mov    %rax,%r8
  8012d5:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012da:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  8012e1:	00 00 00 
  8012e4:	be 26 00 00 00       	mov    $0x26,%esi
  8012e9:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  8012f0:	00 00 00 
  8012f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f8:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  8012ff:	00 00 00 
  801302:	41 ff d1             	call   *%r9

0000000000801305 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801305:	f3 0f 1e fa          	endbr64
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	53                   	push   %rbx
  80130e:	48 83 ec 08          	sub    $0x8,%rsp
  801312:	48 89 f1             	mov    %rsi,%rcx
  801315:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801318:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80131b:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801320:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801325:	be 00 00 00 00       	mov    $0x0,%esi
  80132a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801330:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801332:	48 85 c0             	test   %rax,%rax
  801335:	7f 06                	jg     80133d <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801337:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80133b:	c9                   	leave
  80133c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80133d:	49 89 c0             	mov    %rax,%r8
  801340:	b9 07 00 00 00       	mov    $0x7,%ecx
  801345:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  80134c:	00 00 00 
  80134f:	be 26 00 00 00       	mov    $0x26,%esi
  801354:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  80135b:	00 00 00 
  80135e:	b8 00 00 00 00       	mov    $0x0,%eax
  801363:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  80136a:	00 00 00 
  80136d:	41 ff d1             	call   *%r9

0000000000801370 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801370:	f3 0f 1e fa          	endbr64
  801374:	55                   	push   %rbp
  801375:	48 89 e5             	mov    %rsp,%rbp
  801378:	53                   	push   %rbx
  801379:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80137d:	48 63 ce             	movslq %esi,%rcx
  801380:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801383:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801388:	bb 00 00 00 00       	mov    $0x0,%ebx
  80138d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801392:	be 00 00 00 00       	mov    $0x0,%esi
  801397:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80139d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80139f:	48 85 c0             	test   %rax,%rax
  8013a2:	7f 06                	jg     8013aa <sys_env_set_status+0x3a>
}
  8013a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a8:	c9                   	leave
  8013a9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013aa:	49 89 c0             	mov    %rax,%r8
  8013ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b2:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  8013b9:	00 00 00 
  8013bc:	be 26 00 00 00       	mov    $0x26,%esi
  8013c1:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  8013c8:	00 00 00 
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  8013d7:	00 00 00 
  8013da:	41 ff d1             	call   *%r9

00000000008013dd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8013dd:	f3 0f 1e fa          	endbr64
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	53                   	push   %rbx
  8013e6:	48 83 ec 08          	sub    $0x8,%rsp
  8013ea:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8013ed:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013f0:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ff:	be 00 00 00 00       	mov    $0x0,%esi
  801404:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80140a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80140c:	48 85 c0             	test   %rax,%rax
  80140f:	7f 06                	jg     801417 <sys_env_set_trapframe+0x3a>
}
  801411:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801415:	c9                   	leave
  801416:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801417:	49 89 c0             	mov    %rax,%r8
  80141a:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80141f:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  801426:	00 00 00 
  801429:	be 26 00 00 00       	mov    $0x26,%esi
  80142e:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  801435:	00 00 00 
  801438:	b8 00 00 00 00       	mov    $0x0,%eax
  80143d:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  801444:	00 00 00 
  801447:	41 ff d1             	call   *%r9

000000000080144a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80144a:	f3 0f 1e fa          	endbr64
  80144e:	55                   	push   %rbp
  80144f:	48 89 e5             	mov    %rsp,%rbp
  801452:	53                   	push   %rbx
  801453:	48 83 ec 08          	sub    $0x8,%rsp
  801457:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80145a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80145d:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801462:	bb 00 00 00 00       	mov    $0x0,%ebx
  801467:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80146c:	be 00 00 00 00       	mov    $0x0,%esi
  801471:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801477:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801479:	48 85 c0             	test   %rax,%rax
  80147c:	7f 06                	jg     801484 <sys_env_set_pgfault_upcall+0x3a>
}
  80147e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801482:	c9                   	leave
  801483:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801484:	49 89 c0             	mov    %rax,%r8
  801487:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80148c:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  801493:	00 00 00 
  801496:	be 26 00 00 00       	mov    $0x26,%esi
  80149b:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  8014a2:	00 00 00 
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  8014b1:	00 00 00 
  8014b4:	41 ff d1             	call   *%r9

00000000008014b7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014b7:	f3 0f 1e fa          	endbr64
  8014bb:	55                   	push   %rbp
  8014bc:	48 89 e5             	mov    %rsp,%rbp
  8014bf:	53                   	push   %rbx
  8014c0:	89 f8                	mov    %edi,%eax
  8014c2:	49 89 f1             	mov    %rsi,%r9
  8014c5:	48 89 d3             	mov    %rdx,%rbx
  8014c8:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014cb:	49 63 f0             	movslq %r8d,%rsi
  8014ce:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d1:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014d6:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014df:	cd 30                	int    $0x30
}
  8014e1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e5:	c9                   	leave
  8014e6:	c3                   	ret

00000000008014e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8014e7:	f3 0f 1e fa          	endbr64
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	53                   	push   %rbx
  8014f0:	48 83 ec 08          	sub    $0x8,%rsp
  8014f4:	48 89 fa             	mov    %rdi,%rdx
  8014f7:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014fa:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801504:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801509:	be 00 00 00 00       	mov    $0x0,%esi
  80150e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801514:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801516:	48 85 c0             	test   %rax,%rax
  801519:	7f 06                	jg     801521 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80151b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80151f:	c9                   	leave
  801520:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801521:	49 89 c0             	mov    %rax,%r8
  801524:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801529:	48 ba 98 40 80 00 00 	movabs $0x804098,%rdx
  801530:	00 00 00 
  801533:	be 26 00 00 00       	mov    $0x26,%esi
  801538:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  80153f:	00 00 00 
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
  801547:	49 b9 4c 2c 80 00 00 	movabs $0x802c4c,%r9
  80154e:	00 00 00 
  801551:	41 ff d1             	call   *%r9

0000000000801554 <sys_gettime>:

int
sys_gettime(void) {
  801554:	f3 0f 1e fa          	endbr64
  801558:	55                   	push   %rbp
  801559:	48 89 e5             	mov    %rsp,%rbp
  80155c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80155d:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801562:	ba 00 00 00 00       	mov    $0x0,%edx
  801567:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80156c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801571:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801576:	be 00 00 00 00       	mov    $0x0,%esi
  80157b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801581:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801583:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801587:	c9                   	leave
  801588:	c3                   	ret

0000000000801589 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801589:	f3 0f 1e fa          	endbr64
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	41 56                	push   %r14
  801593:	41 55                	push   %r13
  801595:	41 54                	push   %r12
  801597:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  801598:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80159f:	00 00 00 
  8015a2:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8015a9:	b8 09 00 00 00       	mov    $0x9,%eax
  8015ae:	cd 30                	int    $0x30
  8015b0:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 7f                	js     801636 <fork+0xad>
  8015b7:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8015b9:	0f 84 83 00 00 00    	je     801642 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8015bf:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  8015c5:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8015cc:	00 00 00 
  8015cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015d4:	89 c2                	mov    %eax,%edx
  8015d6:	be 00 00 00 00       	mov    $0x0,%esi
  8015db:	bf 00 00 00 00       	mov    $0x0,%edi
  8015e0:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	call   *%rax
  8015ec:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	0f 88 81 00 00 00    	js     801678 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  8015f7:	4d 85 f6             	test   %r14,%r14
  8015fa:	74 20                	je     80161c <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8015fc:	48 be f3 2c 80 00 00 	movabs $0x802cf3,%rsi
  801603:	00 00 00 
  801606:	44 89 e7             	mov    %r12d,%edi
  801609:	48 b8 4a 14 80 00 00 	movabs $0x80144a,%rax
  801610:	00 00 00 
  801613:	ff d0                	call   *%rax
  801615:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 70                	js     80168c <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80161c:	be 02 00 00 00       	mov    $0x2,%esi
  801621:	89 df                	mov    %ebx,%edi
  801623:	48 b8 70 13 80 00 00 	movabs $0x801370,%rax
  80162a:	00 00 00 
  80162d:	ff d0                	call   *%rax
  80162f:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801632:	85 c0                	test   %eax,%eax
  801634:	78 6a                	js     8016a0 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801636:	44 89 e0             	mov    %r12d,%eax
  801639:	5b                   	pop    %rbx
  80163a:	41 5c                	pop    %r12
  80163c:	41 5d                	pop    %r13
  80163e:	41 5e                	pop    %r14
  801640:	5d                   	pop    %rbp
  801641:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801642:	48 b8 f5 10 80 00 00 	movabs $0x8010f5,%rax
  801649:	00 00 00 
  80164c:	ff d0                	call   *%rax
  80164e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801653:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801657:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80165b:	48 c1 e0 04          	shl    $0x4,%rax
  80165f:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801666:	00 00 00 
  801669:	48 01 d0             	add    %rdx,%rax
  80166c:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801673:	00 00 00 
        return 0;
  801676:	eb be                	jmp    801636 <fork+0xad>
        sys_env_destroy(envid);
  801678:	44 89 e7             	mov    %r12d,%edi
  80167b:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  801682:	00 00 00 
  801685:	ff d0                	call   *%rax
        return res;
  801687:	45 89 ec             	mov    %r13d,%r12d
  80168a:	eb aa                	jmp    801636 <fork+0xad>
            sys_env_destroy(envid);
  80168c:	44 89 e7             	mov    %r12d,%edi
  80168f:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  801696:	00 00 00 
  801699:	ff d0                	call   *%rax
            return res;
  80169b:	45 89 ec             	mov    %r13d,%r12d
  80169e:	eb 96                	jmp    801636 <fork+0xad>
        sys_env_destroy(envid);
  8016a0:	89 df                	mov    %ebx,%edi
  8016a2:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  8016a9:	00 00 00 
  8016ac:	ff d0                	call   *%rax
        return res;
  8016ae:	45 89 ec             	mov    %r13d,%r12d
  8016b1:	eb 83                	jmp    801636 <fork+0xad>

00000000008016b3 <sfork>:

envid_t
sfork() {
  8016b3:	f3 0f 1e fa          	endbr64
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8016bb:	48 ba 45 43 80 00 00 	movabs $0x804345,%rdx
  8016c2:	00 00 00 
  8016c5:	be 37 00 00 00       	mov    $0x37,%esi
  8016ca:	48 bf 60 43 80 00 00 	movabs $0x804360,%rdi
  8016d1:	00 00 00 
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d9:	48 b9 4c 2c 80 00 00 	movabs $0x802c4c,%rcx
  8016e0:	00 00 00 
  8016e3:	ff d1                	call   *%rcx

00000000008016e5 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8016e5:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016e9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016f0:	ff ff ff 
  8016f3:	48 01 f8             	add    %rdi,%rax
  8016f6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8016fa:	c3                   	ret

00000000008016fb <fd2data>:

char *
fd2data(struct Fd *fd) {
  8016fb:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016ff:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801706:	ff ff ff 
  801709:	48 01 f8             	add    %rdi,%rax
  80170c:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801710:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801716:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80171a:	c3                   	ret

000000000080171b <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80171b:	f3 0f 1e fa          	endbr64
  80171f:	55                   	push   %rbp
  801720:	48 89 e5             	mov    %rsp,%rbp
  801723:	41 57                	push   %r15
  801725:	41 56                	push   %r14
  801727:	41 55                	push   %r13
  801729:	41 54                	push   %r12
  80172b:	53                   	push   %rbx
  80172c:	48 83 ec 08          	sub    $0x8,%rsp
  801730:	49 89 ff             	mov    %rdi,%r15
  801733:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801738:	49 bd 7a 28 80 00 00 	movabs $0x80287a,%r13
  80173f:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801742:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801748:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80174b:	48 89 df             	mov    %rbx,%rdi
  80174e:	41 ff d5             	call   *%r13
  801751:	83 e0 04             	and    $0x4,%eax
  801754:	74 17                	je     80176d <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801756:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80175d:	4c 39 f3             	cmp    %r14,%rbx
  801760:	75 e6                	jne    801748 <fd_alloc+0x2d>
  801762:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801768:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80176d:	4d 89 27             	mov    %r12,(%r15)
}
  801770:	48 83 c4 08          	add    $0x8,%rsp
  801774:	5b                   	pop    %rbx
  801775:	41 5c                	pop    %r12
  801777:	41 5d                	pop    %r13
  801779:	41 5e                	pop    %r14
  80177b:	41 5f                	pop    %r15
  80177d:	5d                   	pop    %rbp
  80177e:	c3                   	ret

000000000080177f <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80177f:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801783:	83 ff 1f             	cmp    $0x1f,%edi
  801786:	77 39                	ja     8017c1 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	41 54                	push   %r12
  80178e:	53                   	push   %rbx
  80178f:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801792:	48 63 df             	movslq %edi,%rbx
  801795:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80179c:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8017a0:	48 89 df             	mov    %rbx,%rdi
  8017a3:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  8017aa:	00 00 00 
  8017ad:	ff d0                	call   *%rax
  8017af:	a8 04                	test   $0x4,%al
  8017b1:	74 14                	je     8017c7 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8017b3:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bc:	5b                   	pop    %rbx
  8017bd:	41 5c                	pop    %r12
  8017bf:	5d                   	pop    %rbp
  8017c0:	c3                   	ret
        return -E_INVAL;
  8017c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017c6:	c3                   	ret
        return -E_INVAL;
  8017c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cc:	eb ee                	jmp    8017bc <fd_lookup+0x3d>

00000000008017ce <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8017ce:	f3 0f 1e fa          	endbr64
  8017d2:	55                   	push   %rbp
  8017d3:	48 89 e5             	mov    %rsp,%rbp
  8017d6:	41 54                	push   %r12
  8017d8:	53                   	push   %rbx
  8017d9:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8017dc:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  8017e3:	00 00 00 
  8017e6:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  8017ed:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8017f0:	39 3b                	cmp    %edi,(%rbx)
  8017f2:	74 47                	je     80183b <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8017f4:	48 83 c0 08          	add    $0x8,%rax
  8017f8:	48 8b 18             	mov    (%rax),%rbx
  8017fb:	48 85 db             	test   %rbx,%rbx
  8017fe:	75 f0                	jne    8017f0 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801800:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801807:	00 00 00 
  80180a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801810:	89 fa                	mov    %edi,%edx
  801812:	48 bf b8 40 80 00 00 	movabs $0x8040b8,%rdi
  801819:	00 00 00 
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801828:	00 00 00 
  80182b:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80182d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801832:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801836:	5b                   	pop    %rbx
  801837:	41 5c                	pop    %r12
  801839:	5d                   	pop    %rbp
  80183a:	c3                   	ret
            return 0;
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
  801840:	eb f0                	jmp    801832 <dev_lookup+0x64>

0000000000801842 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801842:	f3 0f 1e fa          	endbr64
  801846:	55                   	push   %rbp
  801847:	48 89 e5             	mov    %rsp,%rbp
  80184a:	41 55                	push   %r13
  80184c:	41 54                	push   %r12
  80184e:	53                   	push   %rbx
  80184f:	48 83 ec 18          	sub    $0x18,%rsp
  801853:	48 89 fb             	mov    %rdi,%rbx
  801856:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801859:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801860:	ff ff ff 
  801863:	48 01 df             	add    %rbx,%rdi
  801866:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80186a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80186e:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801875:	00 00 00 
  801878:	ff d0                	call   *%rax
  80187a:	41 89 c5             	mov    %eax,%r13d
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 06                	js     801887 <fd_close+0x45>
  801881:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801885:	74 1a                	je     8018a1 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801887:	45 84 e4             	test   %r12b,%r12b
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
  80188f:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801893:	44 89 e8             	mov    %r13d,%eax
  801896:	48 83 c4 18          	add    $0x18,%rsp
  80189a:	5b                   	pop    %rbx
  80189b:	41 5c                	pop    %r12
  80189d:	41 5d                	pop    %r13
  80189f:	5d                   	pop    %rbp
  8018a0:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018a1:	8b 3b                	mov    (%rbx),%edi
  8018a3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018a7:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8018ae:	00 00 00 
  8018b1:	ff d0                	call   *%rax
  8018b3:	41 89 c5             	mov    %eax,%r13d
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 1b                	js     8018d5 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8018ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018be:	48 8b 40 20          	mov    0x20(%rax),%rax
  8018c2:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8018c8:	48 85 c0             	test   %rax,%rax
  8018cb:	74 08                	je     8018d5 <fd_close+0x93>
  8018cd:	48 89 df             	mov    %rbx,%rdi
  8018d0:	ff d0                	call   *%rax
  8018d2:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8018d5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018da:	48 89 de             	mov    %rbx,%rsi
  8018dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8018e2:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	call   *%rax
    return res;
  8018ee:	eb a3                	jmp    801893 <fd_close+0x51>

00000000008018f0 <close>:

int
close(int fdnum) {
  8018f0:	f3 0f 1e fa          	endbr64
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
  8018f8:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8018fc:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801900:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801907:	00 00 00 
  80190a:	ff d0                	call   *%rax
    if (res < 0) return res;
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 15                	js     801925 <close+0x35>

    return fd_close(fd, 1);
  801910:	be 01 00 00 00       	mov    $0x1,%esi
  801915:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801919:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  801920:	00 00 00 
  801923:	ff d0                	call   *%rax
}
  801925:	c9                   	leave
  801926:	c3                   	ret

0000000000801927 <close_all>:

void
close_all(void) {
  801927:	f3 0f 1e fa          	endbr64
  80192b:	55                   	push   %rbp
  80192c:	48 89 e5             	mov    %rsp,%rbp
  80192f:	41 54                	push   %r12
  801931:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801932:	bb 00 00 00 00       	mov    $0x0,%ebx
  801937:	49 bc f0 18 80 00 00 	movabs $0x8018f0,%r12
  80193e:	00 00 00 
  801941:	89 df                	mov    %ebx,%edi
  801943:	41 ff d4             	call   *%r12
  801946:	83 c3 01             	add    $0x1,%ebx
  801949:	83 fb 20             	cmp    $0x20,%ebx
  80194c:	75 f3                	jne    801941 <close_all+0x1a>
}
  80194e:	5b                   	pop    %rbx
  80194f:	41 5c                	pop    %r12
  801951:	5d                   	pop    %rbp
  801952:	c3                   	ret

0000000000801953 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801953:	f3 0f 1e fa          	endbr64
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
  80195b:	41 57                	push   %r15
  80195d:	41 56                	push   %r14
  80195f:	41 55                	push   %r13
  801961:	41 54                	push   %r12
  801963:	53                   	push   %rbx
  801964:	48 83 ec 18          	sub    $0x18,%rsp
  801968:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80196b:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80196f:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801976:	00 00 00 
  801979:	ff d0                	call   *%rax
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	85 c0                	test   %eax,%eax
  80197f:	0f 88 b8 00 00 00    	js     801a3d <dup+0xea>
    close(newfdnum);
  801985:	44 89 e7             	mov    %r12d,%edi
  801988:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  80198f:	00 00 00 
  801992:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801994:	4d 63 ec             	movslq %r12d,%r13
  801997:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80199e:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8019a2:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8019a6:	4c 89 ff             	mov    %r15,%rdi
  8019a9:	49 be fb 16 80 00 00 	movabs $0x8016fb,%r14
  8019b0:	00 00 00 
  8019b3:	41 ff d6             	call   *%r14
  8019b6:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8019b9:	4c 89 ef             	mov    %r13,%rdi
  8019bc:	41 ff d6             	call   *%r14
  8019bf:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8019c2:	48 89 df             	mov    %rbx,%rdi
  8019c5:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8019d1:	a8 04                	test   $0x4,%al
  8019d3:	74 2b                	je     801a00 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8019d5:	41 89 c1             	mov    %eax,%r9d
  8019d8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019de:	4c 89 f1             	mov    %r14,%rcx
  8019e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e6:	48 89 de             	mov    %rbx,%rsi
  8019e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ee:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	call   *%rax
  8019fa:	89 c3                	mov    %eax,%ebx
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 4e                	js     801a4e <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801a00:	4c 89 ff             	mov    %r15,%rdi
  801a03:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  801a0a:	00 00 00 
  801a0d:	ff d0                	call   *%rax
  801a0f:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a12:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a18:	4c 89 e9             	mov    %r13,%rcx
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	4c 89 fe             	mov    %r15,%rsi
  801a23:	bf 00 00 00 00       	mov    $0x0,%edi
  801a28:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	call   *%rax
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 14                	js     801a4e <dup+0xfb>

    return newfdnum;
  801a3a:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a3d:	89 d8                	mov    %ebx,%eax
  801a3f:	48 83 c4 18          	add    $0x18,%rsp
  801a43:	5b                   	pop    %rbx
  801a44:	41 5c                	pop    %r12
  801a46:	41 5d                	pop    %r13
  801a48:	41 5e                	pop    %r14
  801a4a:	41 5f                	pop    %r15
  801a4c:	5d                   	pop    %rbp
  801a4d:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a4e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a53:	4c 89 ee             	mov    %r13,%rsi
  801a56:	bf 00 00 00 00       	mov    $0x0,%edi
  801a5b:	49 bc 05 13 80 00 00 	movabs $0x801305,%r12
  801a62:	00 00 00 
  801a65:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a68:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a6d:	4c 89 f6             	mov    %r14,%rsi
  801a70:	bf 00 00 00 00       	mov    $0x0,%edi
  801a75:	41 ff d4             	call   *%r12
    return res;
  801a78:	eb c3                	jmp    801a3d <dup+0xea>

0000000000801a7a <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801a7a:	f3 0f 1e fa          	endbr64
  801a7e:	55                   	push   %rbp
  801a7f:	48 89 e5             	mov    %rsp,%rbp
  801a82:	41 56                	push   %r14
  801a84:	41 55                	push   %r13
  801a86:	41 54                	push   %r12
  801a88:	53                   	push   %rbx
  801a89:	48 83 ec 10          	sub    $0x10,%rsp
  801a8d:	89 fb                	mov    %edi,%ebx
  801a8f:	49 89 f4             	mov    %rsi,%r12
  801a92:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a95:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a99:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801aa0:	00 00 00 
  801aa3:	ff d0                	call   *%rax
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 4c                	js     801af5 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801aa9:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801aad:	41 8b 3e             	mov    (%r14),%edi
  801ab0:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ab4:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  801abb:	00 00 00 
  801abe:	ff d0                	call   *%rax
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 35                	js     801af9 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ac4:	41 8b 46 08          	mov    0x8(%r14),%eax
  801ac8:	83 e0 03             	and    $0x3,%eax
  801acb:	83 f8 01             	cmp    $0x1,%eax
  801ace:	74 2d                	je     801afd <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801ad0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ad4:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ad8:	48 85 c0             	test   %rax,%rax
  801adb:	74 56                	je     801b33 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801add:	4c 89 ea             	mov    %r13,%rdx
  801ae0:	4c 89 e6             	mov    %r12,%rsi
  801ae3:	4c 89 f7             	mov    %r14,%rdi
  801ae6:	ff d0                	call   *%rax
}
  801ae8:	48 83 c4 10          	add    $0x10,%rsp
  801aec:	5b                   	pop    %rbx
  801aed:	41 5c                	pop    %r12
  801aef:	41 5d                	pop    %r13
  801af1:	41 5e                	pop    %r14
  801af3:	5d                   	pop    %rbp
  801af4:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801af5:	48 98                	cltq
  801af7:	eb ef                	jmp    801ae8 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801af9:	48 98                	cltq
  801afb:	eb eb                	jmp    801ae8 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801afd:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b04:	00 00 00 
  801b07:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b0d:	89 da                	mov    %ebx,%edx
  801b0f:	48 bf 6b 43 80 00 00 	movabs $0x80436b,%rdi
  801b16:	00 00 00 
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1e:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801b25:	00 00 00 
  801b28:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b2a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b31:	eb b5                	jmp    801ae8 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b33:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b3a:	eb ac                	jmp    801ae8 <read+0x6e>

0000000000801b3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b3c:	f3 0f 1e fa          	endbr64
  801b40:	55                   	push   %rbp
  801b41:	48 89 e5             	mov    %rsp,%rbp
  801b44:	41 57                	push   %r15
  801b46:	41 56                	push   %r14
  801b48:	41 55                	push   %r13
  801b4a:	41 54                	push   %r12
  801b4c:	53                   	push   %rbx
  801b4d:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b51:	48 85 d2             	test   %rdx,%rdx
  801b54:	74 54                	je     801baa <readn+0x6e>
  801b56:	41 89 fd             	mov    %edi,%r13d
  801b59:	49 89 f6             	mov    %rsi,%r14
  801b5c:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b5f:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b64:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b69:	49 bf 7a 1a 80 00 00 	movabs $0x801a7a,%r15
  801b70:	00 00 00 
  801b73:	4c 89 e2             	mov    %r12,%rdx
  801b76:	48 29 f2             	sub    %rsi,%rdx
  801b79:	4c 01 f6             	add    %r14,%rsi
  801b7c:	44 89 ef             	mov    %r13d,%edi
  801b7f:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 20                	js     801ba6 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801b86:	01 c3                	add    %eax,%ebx
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	74 08                	je     801b94 <readn+0x58>
  801b8c:	48 63 f3             	movslq %ebx,%rsi
  801b8f:	4c 39 e6             	cmp    %r12,%rsi
  801b92:	72 df                	jb     801b73 <readn+0x37>
    }
    return res;
  801b94:	48 63 c3             	movslq %ebx,%rax
}
  801b97:	48 83 c4 08          	add    $0x8,%rsp
  801b9b:	5b                   	pop    %rbx
  801b9c:	41 5c                	pop    %r12
  801b9e:	41 5d                	pop    %r13
  801ba0:	41 5e                	pop    %r14
  801ba2:	41 5f                	pop    %r15
  801ba4:	5d                   	pop    %rbp
  801ba5:	c3                   	ret
        if (inc < 0) return inc;
  801ba6:	48 98                	cltq
  801ba8:	eb ed                	jmp    801b97 <readn+0x5b>
    int inc = 1, res = 0;
  801baa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801baf:	eb e3                	jmp    801b94 <readn+0x58>

0000000000801bb1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801bb1:	f3 0f 1e fa          	endbr64
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	41 56                	push   %r14
  801bbb:	41 55                	push   %r13
  801bbd:	41 54                	push   %r12
  801bbf:	53                   	push   %rbx
  801bc0:	48 83 ec 10          	sub    $0x10,%rsp
  801bc4:	89 fb                	mov    %edi,%ebx
  801bc6:	49 89 f4             	mov    %rsi,%r12
  801bc9:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bcc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bd0:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801bd7:	00 00 00 
  801bda:	ff d0                	call   *%rax
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 47                	js     801c27 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801be0:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801be4:	41 8b 3e             	mov    (%r14),%edi
  801be7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801beb:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	call   *%rax
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	78 30                	js     801c2b <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bfb:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801c00:	74 2d                	je     801c2f <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c06:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c0a:	48 85 c0             	test   %rax,%rax
  801c0d:	74 56                	je     801c65 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801c0f:	4c 89 ea             	mov    %r13,%rdx
  801c12:	4c 89 e6             	mov    %r12,%rsi
  801c15:	4c 89 f7             	mov    %r14,%rdi
  801c18:	ff d0                	call   *%rax
}
  801c1a:	48 83 c4 10          	add    $0x10,%rsp
  801c1e:	5b                   	pop    %rbx
  801c1f:	41 5c                	pop    %r12
  801c21:	41 5d                	pop    %r13
  801c23:	41 5e                	pop    %r14
  801c25:	5d                   	pop    %rbp
  801c26:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c27:	48 98                	cltq
  801c29:	eb ef                	jmp    801c1a <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c2b:	48 98                	cltq
  801c2d:	eb eb                	jmp    801c1a <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c2f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c36:	00 00 00 
  801c39:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c3f:	89 da                	mov    %ebx,%edx
  801c41:	48 bf 87 43 80 00 00 	movabs $0x804387,%rdi
  801c48:	00 00 00 
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801c57:	00 00 00 
  801c5a:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c5c:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c63:	eb b5                	jmp    801c1a <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c65:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c6c:	eb ac                	jmp    801c1a <write+0x69>

0000000000801c6e <seek>:

int
seek(int fdnum, off_t offset) {
  801c6e:	f3 0f 1e fa          	endbr64
  801c72:	55                   	push   %rbp
  801c73:	48 89 e5             	mov    %rsp,%rbp
  801c76:	53                   	push   %rbx
  801c77:	48 83 ec 18          	sub    $0x18,%rsp
  801c7b:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c7d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c81:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	call   *%rax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	78 0c                	js     801c9d <seek+0x2f>

    fd->fd_offset = offset;
  801c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c95:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ca1:	c9                   	leave
  801ca2:	c3                   	ret

0000000000801ca3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ca3:	f3 0f 1e fa          	endbr64
  801ca7:	55                   	push   %rbp
  801ca8:	48 89 e5             	mov    %rsp,%rbp
  801cab:	41 55                	push   %r13
  801cad:	41 54                	push   %r12
  801caf:	53                   	push   %rbx
  801cb0:	48 83 ec 18          	sub    $0x18,%rsp
  801cb4:	89 fb                	mov    %edi,%ebx
  801cb6:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cb9:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cbd:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	call   *%rax
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	78 38                	js     801d05 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ccd:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801cd1:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801cd5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cd9:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	call   *%rax
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	78 1c                	js     801d05 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ce9:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801cee:	74 20                	je     801d10 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801cf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cf4:	48 8b 40 30          	mov    0x30(%rax),%rax
  801cf8:	48 85 c0             	test   %rax,%rax
  801cfb:	74 47                	je     801d44 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801cfd:	44 89 e6             	mov    %r12d,%esi
  801d00:	4c 89 ef             	mov    %r13,%rdi
  801d03:	ff d0                	call   *%rax
}
  801d05:	48 83 c4 18          	add    $0x18,%rsp
  801d09:	5b                   	pop    %rbx
  801d0a:	41 5c                	pop    %r12
  801d0c:	41 5d                	pop    %r13
  801d0e:	5d                   	pop    %rbp
  801d0f:	c3                   	ret
                thisenv->env_id, fdnum);
  801d10:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d17:	00 00 00 
  801d1a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d20:	89 da                	mov    %ebx,%edx
  801d22:	48 bf d8 40 80 00 00 	movabs $0x8040d8,%rdi
  801d29:	00 00 00 
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d31:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801d38:	00 00 00 
  801d3b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d42:	eb c1                	jmp    801d05 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d44:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d49:	eb ba                	jmp    801d05 <ftruncate+0x62>

0000000000801d4b <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d4b:	f3 0f 1e fa          	endbr64
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	41 54                	push   %r12
  801d55:	53                   	push   %rbx
  801d56:	48 83 ec 10          	sub    $0x10,%rsp
  801d5a:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d5d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d61:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	call   *%rax
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 4e                	js     801dbf <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d71:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801d75:	41 8b 3c 24          	mov    (%r12),%edi
  801d79:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d7d:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	call   *%rax
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	78 32                	js     801dbf <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d91:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801d96:	74 30                	je     801dc8 <fstat+0x7d>

    stat->st_name[0] = 0;
  801d98:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801d9b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801da2:	00 00 00 
    stat->st_isdir = 0;
  801da5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801dac:	00 00 00 
    stat->st_dev = dev;
  801daf:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801db6:	48 89 de             	mov    %rbx,%rsi
  801db9:	4c 89 e7             	mov    %r12,%rdi
  801dbc:	ff 50 28             	call   *0x28(%rax)
}
  801dbf:	48 83 c4 10          	add    $0x10,%rsp
  801dc3:	5b                   	pop    %rbx
  801dc4:	41 5c                	pop    %r12
  801dc6:	5d                   	pop    %rbp
  801dc7:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801dc8:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801dcd:	eb f0                	jmp    801dbf <fstat+0x74>

0000000000801dcf <stat>:

int
stat(const char *path, struct Stat *stat) {
  801dcf:	f3 0f 1e fa          	endbr64
  801dd3:	55                   	push   %rbp
  801dd4:	48 89 e5             	mov    %rsp,%rbp
  801dd7:	41 54                	push   %r12
  801dd9:	53                   	push   %rbx
  801dda:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801ddd:	be 00 00 00 00       	mov    $0x0,%esi
  801de2:	48 b8 b0 20 80 00 00 	movabs $0x8020b0,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	call   *%rax
  801dee:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801df0:	85 c0                	test   %eax,%eax
  801df2:	78 25                	js     801e19 <stat+0x4a>

    int res = fstat(fd, stat);
  801df4:	4c 89 e6             	mov    %r12,%rsi
  801df7:	89 c7                	mov    %eax,%edi
  801df9:	48 b8 4b 1d 80 00 00 	movabs $0x801d4b,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	call   *%rax
  801e05:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e08:	89 df                	mov    %ebx,%edi
  801e0a:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	call   *%rax

    return res;
  801e16:	44 89 e3             	mov    %r12d,%ebx
}
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	5b                   	pop    %rbx
  801e1c:	41 5c                	pop    %r12
  801e1e:	5d                   	pop    %rbp
  801e1f:	c3                   	ret

0000000000801e20 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e20:	f3 0f 1e fa          	endbr64
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
  801e28:	41 54                	push   %r12
  801e2a:	53                   	push   %rbx
  801e2b:	48 83 ec 10          	sub    $0x10,%rsp
  801e2f:	41 89 fc             	mov    %edi,%r12d
  801e32:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e35:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e3c:	00 00 00 
  801e3f:	83 38 00             	cmpl   $0x0,(%rax)
  801e42:	74 6e                	je     801eb2 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801e44:	bf 03 00 00 00       	mov    $0x3,%edi
  801e49:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	call   *%rax
  801e55:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801e5c:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e5e:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e64:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e69:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801e70:	00 00 00 
  801e73:	44 89 e6             	mov    %r12d,%esi
  801e76:	89 c7                	mov    %eax,%edi
  801e78:	48 b8 12 2e 80 00 00 	movabs $0x802e12,%rax
  801e7f:	00 00 00 
  801e82:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801e84:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801e8b:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801e8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e91:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e95:	48 89 de             	mov    %rbx,%rsi
  801e98:	bf 00 00 00 00       	mov    $0x0,%edi
  801e9d:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  801ea4:	00 00 00 
  801ea7:	ff d0                	call   *%rax
}
  801ea9:	48 83 c4 10          	add    $0x10,%rsp
  801ead:	5b                   	pop    %rbx
  801eae:	41 5c                	pop    %r12
  801eb0:	5d                   	pop    %rbp
  801eb1:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801eb2:	bf 03 00 00 00       	mov    $0x3,%edi
  801eb7:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	call   *%rax
  801ec3:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801eca:	00 00 
  801ecc:	e9 73 ff ff ff       	jmp    801e44 <fsipc+0x24>

0000000000801ed1 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ed1:	f3 0f 1e fa          	endbr64
  801ed5:	55                   	push   %rbp
  801ed6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ed9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ee0:	00 00 00 
  801ee3:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ee6:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801ee8:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801eeb:	be 00 00 00 00       	mov    $0x0,%esi
  801ef0:	bf 02 00 00 00       	mov    $0x2,%edi
  801ef5:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	call   *%rax
}
  801f01:	5d                   	pop    %rbp
  801f02:	c3                   	ret

0000000000801f03 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f03:	f3 0f 1e fa          	endbr64
  801f07:	55                   	push   %rbp
  801f08:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f0b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f0e:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f15:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f17:	be 00 00 00 00       	mov    $0x0,%esi
  801f1c:	bf 06 00 00 00       	mov    $0x6,%edi
  801f21:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801f28:	00 00 00 
  801f2b:	ff d0                	call   *%rax
}
  801f2d:	5d                   	pop    %rbp
  801f2e:	c3                   	ret

0000000000801f2f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f2f:	f3 0f 1e fa          	endbr64
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	41 54                	push   %r12
  801f39:	53                   	push   %rbx
  801f3a:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f3d:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f40:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f47:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f49:	be 00 00 00 00       	mov    $0x0,%esi
  801f4e:	bf 05 00 00 00       	mov    $0x5,%edi
  801f53:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 3d                	js     801fa0 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f63:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  801f6a:	00 00 00 
  801f6d:	4c 89 e6             	mov    %r12,%rsi
  801f70:	48 89 df             	mov    %rbx,%rdi
  801f73:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  801f7a:	00 00 00 
  801f7d:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801f7f:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801f86:	00 
  801f87:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f8d:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801f94:	00 
  801f95:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa0:	5b                   	pop    %rbx
  801fa1:	41 5c                	pop    %r12
  801fa3:	5d                   	pop    %rbp
  801fa4:	c3                   	ret

0000000000801fa5 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fa5:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801fa9:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801fb0:	77 41                	ja     801ff3 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fb2:	55                   	push   %rbp
  801fb3:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fb6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fbd:	00 00 00 
  801fc0:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801fc3:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801fc5:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801fc9:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801fcd:	48 b8 db 0d 80 00 00 	movabs $0x800ddb,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801fd9:	be 00 00 00 00       	mov    $0x0,%esi
  801fde:	bf 04 00 00 00       	mov    $0x4,%edi
  801fe3:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  801fea:	00 00 00 
  801fed:	ff d0                	call   *%rax
  801fef:	48 98                	cltq
}
  801ff1:	5d                   	pop    %rbp
  801ff2:	c3                   	ret
        return -E_INVAL;
  801ff3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801ffa:	c3                   	ret

0000000000801ffb <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801ffb:	f3 0f 1e fa          	endbr64
  801fff:	55                   	push   %rbp
  802000:	48 89 e5             	mov    %rsp,%rbp
  802003:	41 55                	push   %r13
  802005:	41 54                	push   %r12
  802007:	53                   	push   %rbx
  802008:	48 83 ec 08          	sub    $0x8,%rsp
  80200c:	49 89 f4             	mov    %rsi,%r12
  80200f:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802012:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802019:	00 00 00 
  80201c:	8b 57 0c             	mov    0xc(%rdi),%edx
  80201f:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802021:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802025:	be 00 00 00 00       	mov    $0x0,%esi
  80202a:	bf 03 00 00 00       	mov    $0x3,%edi
  80202f:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802036:	00 00 00 
  802039:	ff d0                	call   *%rax
  80203b:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80203e:	4d 85 ed             	test   %r13,%r13
  802041:	78 2a                	js     80206d <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802043:	4c 89 ea             	mov    %r13,%rdx
  802046:	4c 39 eb             	cmp    %r13,%rbx
  802049:	72 30                	jb     80207b <devfile_read+0x80>
  80204b:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802052:	7f 27                	jg     80207b <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802054:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80205b:	00 00 00 
  80205e:	4c 89 e7             	mov    %r12,%rdi
  802061:	48 b8 db 0d 80 00 00 	movabs $0x800ddb,%rax
  802068:	00 00 00 
  80206b:	ff d0                	call   *%rax
}
  80206d:	4c 89 e8             	mov    %r13,%rax
  802070:	48 83 c4 08          	add    $0x8,%rsp
  802074:	5b                   	pop    %rbx
  802075:	41 5c                	pop    %r12
  802077:	41 5d                	pop    %r13
  802079:	5d                   	pop    %rbp
  80207a:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80207b:	48 b9 a4 43 80 00 00 	movabs $0x8043a4,%rcx
  802082:	00 00 00 
  802085:	48 ba c1 43 80 00 00 	movabs $0x8043c1,%rdx
  80208c:	00 00 00 
  80208f:	be 7b 00 00 00       	mov    $0x7b,%esi
  802094:	48 bf d6 43 80 00 00 	movabs $0x8043d6,%rdi
  80209b:	00 00 00 
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	49 b8 4c 2c 80 00 00 	movabs $0x802c4c,%r8
  8020aa:	00 00 00 
  8020ad:	41 ff d0             	call   *%r8

00000000008020b0 <open>:
open(const char *path, int mode) {
  8020b0:	f3 0f 1e fa          	endbr64
  8020b4:	55                   	push   %rbp
  8020b5:	48 89 e5             	mov    %rsp,%rbp
  8020b8:	41 55                	push   %r13
  8020ba:	41 54                	push   %r12
  8020bc:	53                   	push   %rbx
  8020bd:	48 83 ec 18          	sub    $0x18,%rsp
  8020c1:	49 89 fc             	mov    %rdi,%r12
  8020c4:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8020c7:	48 b8 7b 0b 80 00 00 	movabs $0x800b7b,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	call   *%rax
  8020d3:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8020d9:	0f 87 8a 00 00 00    	ja     802169 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8020df:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8020e3:	48 b8 1b 17 80 00 00 	movabs $0x80171b,%rax
  8020ea:	00 00 00 
  8020ed:	ff d0                	call   *%rax
  8020ef:	89 c3                	mov    %eax,%ebx
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 50                	js     802145 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8020f5:	4c 89 e6             	mov    %r12,%rsi
  8020f8:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8020ff:	00 00 00 
  802102:	48 89 df             	mov    %rbx,%rdi
  802105:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802111:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802118:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80211c:	bf 01 00 00 00       	mov    $0x1,%edi
  802121:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802128:	00 00 00 
  80212b:	ff d0                	call   *%rax
  80212d:	89 c3                	mov    %eax,%ebx
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 1f                	js     802152 <open+0xa2>
    return fd2num(fd);
  802133:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802137:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  80213e:	00 00 00 
  802141:	ff d0                	call   *%rax
  802143:	89 c3                	mov    %eax,%ebx
}
  802145:	89 d8                	mov    %ebx,%eax
  802147:	48 83 c4 18          	add    $0x18,%rsp
  80214b:	5b                   	pop    %rbx
  80214c:	41 5c                	pop    %r12
  80214e:	41 5d                	pop    %r13
  802150:	5d                   	pop    %rbp
  802151:	c3                   	ret
        fd_close(fd, 0);
  802152:	be 00 00 00 00       	mov    $0x0,%esi
  802157:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80215b:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  802162:	00 00 00 
  802165:	ff d0                	call   *%rax
        return res;
  802167:	eb dc                	jmp    802145 <open+0x95>
        return -E_BAD_PATH;
  802169:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80216e:	eb d5                	jmp    802145 <open+0x95>

0000000000802170 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802170:	f3 0f 1e fa          	endbr64
  802174:	55                   	push   %rbp
  802175:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802178:	be 00 00 00 00       	mov    $0x0,%esi
  80217d:	bf 08 00 00 00       	mov    $0x8,%edi
  802182:	48 b8 20 1e 80 00 00 	movabs $0x801e20,%rax
  802189:	00 00 00 
  80218c:	ff d0                	call   *%rax
}
  80218e:	5d                   	pop    %rbp
  80218f:	c3                   	ret

0000000000802190 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802190:	f3 0f 1e fa          	endbr64
  802194:	55                   	push   %rbp
  802195:	48 89 e5             	mov    %rsp,%rbp
  802198:	41 54                	push   %r12
  80219a:	53                   	push   %rbx
  80219b:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80219e:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	call   *%rax
  8021aa:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8021ad:	48 be e1 43 80 00 00 	movabs $0x8043e1,%rsi
  8021b4:	00 00 00 
  8021b7:	48 89 df             	mov    %rbx,%rdi
  8021ba:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8021c6:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8021cb:	41 2b 04 24          	sub    (%r12),%eax
  8021cf:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8021d5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8021dc:	00 00 00 
    stat->st_dev = &devpipe;
  8021df:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8021e6:	00 00 00 
  8021e9:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f5:	5b                   	pop    %rbx
  8021f6:	41 5c                	pop    %r12
  8021f8:	5d                   	pop    %rbp
  8021f9:	c3                   	ret

00000000008021fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8021fa:	f3 0f 1e fa          	endbr64
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	41 54                	push   %r12
  802204:	53                   	push   %rbx
  802205:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802208:	ba 00 10 00 00       	mov    $0x1000,%edx
  80220d:	48 89 fe             	mov    %rdi,%rsi
  802210:	bf 00 00 00 00       	mov    $0x0,%edi
  802215:	49 bc 05 13 80 00 00 	movabs $0x801305,%r12
  80221c:	00 00 00 
  80221f:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802222:	48 89 df             	mov    %rbx,%rdi
  802225:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	call   *%rax
  802231:	48 89 c6             	mov    %rax,%rsi
  802234:	ba 00 10 00 00       	mov    $0x1000,%edx
  802239:	bf 00 00 00 00       	mov    $0x0,%edi
  80223e:	41 ff d4             	call   *%r12
}
  802241:	5b                   	pop    %rbx
  802242:	41 5c                	pop    %r12
  802244:	5d                   	pop    %rbp
  802245:	c3                   	ret

0000000000802246 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802246:	f3 0f 1e fa          	endbr64
  80224a:	55                   	push   %rbp
  80224b:	48 89 e5             	mov    %rsp,%rbp
  80224e:	41 57                	push   %r15
  802250:	41 56                	push   %r14
  802252:	41 55                	push   %r13
  802254:	41 54                	push   %r12
  802256:	53                   	push   %rbx
  802257:	48 83 ec 18          	sub    $0x18,%rsp
  80225b:	49 89 fc             	mov    %rdi,%r12
  80225e:	49 89 f5             	mov    %rsi,%r13
  802261:	49 89 d7             	mov    %rdx,%r15
  802264:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802268:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  80226f:	00 00 00 
  802272:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802274:	4d 85 ff             	test   %r15,%r15
  802277:	0f 84 af 00 00 00    	je     80232c <devpipe_write+0xe6>
  80227d:	48 89 c3             	mov    %rax,%rbx
  802280:	4c 89 f8             	mov    %r15,%rax
  802283:	4d 89 ef             	mov    %r13,%r15
  802286:	4c 01 e8             	add    %r13,%rax
  802289:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80228d:	49 bd 95 11 80 00 00 	movabs $0x801195,%r13
  802294:	00 00 00 
            sys_yield();
  802297:	49 be 2a 11 80 00 00 	movabs $0x80112a,%r14
  80229e:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022a1:	8b 73 04             	mov    0x4(%rbx),%esi
  8022a4:	48 63 ce             	movslq %esi,%rcx
  8022a7:	48 63 03             	movslq (%rbx),%rax
  8022aa:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022b0:	48 39 c1             	cmp    %rax,%rcx
  8022b3:	72 2e                	jb     8022e3 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022b5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022ba:	48 89 da             	mov    %rbx,%rdx
  8022bd:	be 00 10 00 00       	mov    $0x1000,%esi
  8022c2:	4c 89 e7             	mov    %r12,%rdi
  8022c5:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 66                	je     802332 <devpipe_write+0xec>
            sys_yield();
  8022cc:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022cf:	8b 73 04             	mov    0x4(%rbx),%esi
  8022d2:	48 63 ce             	movslq %esi,%rcx
  8022d5:	48 63 03             	movslq (%rbx),%rax
  8022d8:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022de:	48 39 c1             	cmp    %rax,%rcx
  8022e1:	73 d2                	jae    8022b5 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022e3:	41 0f b6 3f          	movzbl (%r15),%edi
  8022e7:	48 89 ca             	mov    %rcx,%rdx
  8022ea:	48 c1 ea 03          	shr    $0x3,%rdx
  8022ee:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8022f5:	08 10 20 
  8022f8:	48 f7 e2             	mul    %rdx
  8022fb:	48 c1 ea 06          	shr    $0x6,%rdx
  8022ff:	48 89 d0             	mov    %rdx,%rax
  802302:	48 c1 e0 09          	shl    $0x9,%rax
  802306:	48 29 d0             	sub    %rdx,%rax
  802309:	48 c1 e0 03          	shl    $0x3,%rax
  80230d:	48 29 c1             	sub    %rax,%rcx
  802310:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802315:	83 c6 01             	add    $0x1,%esi
  802318:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80231b:	49 83 c7 01          	add    $0x1,%r15
  80231f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802323:	49 39 c7             	cmp    %rax,%r15
  802326:	0f 85 75 ff ff ff    	jne    8022a1 <devpipe_write+0x5b>
    return n;
  80232c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802330:	eb 05                	jmp    802337 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802337:	48 83 c4 18          	add    $0x18,%rsp
  80233b:	5b                   	pop    %rbx
  80233c:	41 5c                	pop    %r12
  80233e:	41 5d                	pop    %r13
  802340:	41 5e                	pop    %r14
  802342:	41 5f                	pop    %r15
  802344:	5d                   	pop    %rbp
  802345:	c3                   	ret

0000000000802346 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802346:	f3 0f 1e fa          	endbr64
  80234a:	55                   	push   %rbp
  80234b:	48 89 e5             	mov    %rsp,%rbp
  80234e:	41 57                	push   %r15
  802350:	41 56                	push   %r14
  802352:	41 55                	push   %r13
  802354:	41 54                	push   %r12
  802356:	53                   	push   %rbx
  802357:	48 83 ec 18          	sub    $0x18,%rsp
  80235b:	49 89 fc             	mov    %rdi,%r12
  80235e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802362:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802366:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  80236d:	00 00 00 
  802370:	ff d0                	call   *%rax
  802372:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802375:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80237b:	49 bd 95 11 80 00 00 	movabs $0x801195,%r13
  802382:	00 00 00 
            sys_yield();
  802385:	49 be 2a 11 80 00 00 	movabs $0x80112a,%r14
  80238c:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80238f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802394:	74 7d                	je     802413 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802396:	8b 03                	mov    (%rbx),%eax
  802398:	3b 43 04             	cmp    0x4(%rbx),%eax
  80239b:	75 26                	jne    8023c3 <devpipe_read+0x7d>
            if (i > 0) return i;
  80239d:	4d 85 ff             	test   %r15,%r15
  8023a0:	75 77                	jne    802419 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023a2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023a7:	48 89 da             	mov    %rbx,%rdx
  8023aa:	be 00 10 00 00       	mov    $0x1000,%esi
  8023af:	4c 89 e7             	mov    %r12,%rdi
  8023b2:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 72                	je     80242b <devpipe_read+0xe5>
            sys_yield();
  8023b9:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023bc:	8b 03                	mov    (%rbx),%eax
  8023be:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023c1:	74 df                	je     8023a2 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023c3:	48 63 c8             	movslq %eax,%rcx
  8023c6:	48 89 ca             	mov    %rcx,%rdx
  8023c9:	48 c1 ea 03          	shr    $0x3,%rdx
  8023cd:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8023d4:	08 10 20 
  8023d7:	48 89 d0             	mov    %rdx,%rax
  8023da:	48 f7 e6             	mul    %rsi
  8023dd:	48 c1 ea 06          	shr    $0x6,%rdx
  8023e1:	48 89 d0             	mov    %rdx,%rax
  8023e4:	48 c1 e0 09          	shl    $0x9,%rax
  8023e8:	48 29 d0             	sub    %rdx,%rax
  8023eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023f2:	00 
  8023f3:	48 89 c8             	mov    %rcx,%rax
  8023f6:	48 29 d0             	sub    %rdx,%rax
  8023f9:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8023fe:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802402:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802406:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802409:	49 83 c7 01          	add    $0x1,%r15
  80240d:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802411:	75 83                	jne    802396 <devpipe_read+0x50>
    return n;
  802413:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802417:	eb 03                	jmp    80241c <devpipe_read+0xd6>
            if (i > 0) return i;
  802419:	4c 89 f8             	mov    %r15,%rax
}
  80241c:	48 83 c4 18          	add    $0x18,%rsp
  802420:	5b                   	pop    %rbx
  802421:	41 5c                	pop    %r12
  802423:	41 5d                	pop    %r13
  802425:	41 5e                	pop    %r14
  802427:	41 5f                	pop    %r15
  802429:	5d                   	pop    %rbp
  80242a:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	eb ea                	jmp    80241c <devpipe_read+0xd6>

0000000000802432 <pipe>:
pipe(int pfd[2]) {
  802432:	f3 0f 1e fa          	endbr64
  802436:	55                   	push   %rbp
  802437:	48 89 e5             	mov    %rsp,%rbp
  80243a:	41 55                	push   %r13
  80243c:	41 54                	push   %r12
  80243e:	53                   	push   %rbx
  80243f:	48 83 ec 18          	sub    $0x18,%rsp
  802443:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802446:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80244a:	48 b8 1b 17 80 00 00 	movabs $0x80171b,%rax
  802451:	00 00 00 
  802454:	ff d0                	call   *%rax
  802456:	89 c3                	mov    %eax,%ebx
  802458:	85 c0                	test   %eax,%eax
  80245a:	0f 88 a0 01 00 00    	js     802600 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802460:	b9 46 00 00 00       	mov    $0x46,%ecx
  802465:	ba 00 10 00 00       	mov    $0x1000,%edx
  80246a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80246e:	bf 00 00 00 00       	mov    $0x0,%edi
  802473:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	call   *%rax
  80247f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802481:	85 c0                	test   %eax,%eax
  802483:	0f 88 77 01 00 00    	js     802600 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802489:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80248d:	48 b8 1b 17 80 00 00 	movabs $0x80171b,%rax
  802494:	00 00 00 
  802497:	ff d0                	call   *%rax
  802499:	89 c3                	mov    %eax,%ebx
  80249b:	85 c0                	test   %eax,%eax
  80249d:	0f 88 43 01 00 00    	js     8025e6 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8024a3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024a8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ad:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b6:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  8024bd:	00 00 00 
  8024c0:	ff d0                	call   *%rax
  8024c2:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	0f 88 1a 01 00 00    	js     8025e6 <pipe+0x1b4>
    va = fd2data(fd0);
  8024cc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024d0:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8024d7:	00 00 00 
  8024da:	ff d0                	call   *%rax
  8024dc:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8024df:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024e4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024e9:	48 89 c6             	mov    %rax,%rsi
  8024ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f1:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  8024f8:	00 00 00 
  8024fb:	ff d0                	call   *%rax
  8024fd:	89 c3                	mov    %eax,%ebx
  8024ff:	85 c0                	test   %eax,%eax
  802501:	0f 88 c5 00 00 00    	js     8025cc <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802507:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80250b:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  802512:	00 00 00 
  802515:	ff d0                	call   *%rax
  802517:	48 89 c1             	mov    %rax,%rcx
  80251a:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802520:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802526:	ba 00 00 00 00       	mov    $0x0,%edx
  80252b:	4c 89 ee             	mov    %r13,%rsi
  80252e:	bf 00 00 00 00       	mov    $0x0,%edi
  802533:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  80253a:	00 00 00 
  80253d:	ff d0                	call   *%rax
  80253f:	89 c3                	mov    %eax,%ebx
  802541:	85 c0                	test   %eax,%eax
  802543:	78 6e                	js     8025b3 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802545:	be 00 10 00 00       	mov    $0x1000,%esi
  80254a:	4c 89 ef             	mov    %r13,%rdi
  80254d:	48 b8 5f 11 80 00 00 	movabs $0x80115f,%rax
  802554:	00 00 00 
  802557:	ff d0                	call   *%rax
  802559:	83 f8 02             	cmp    $0x2,%eax
  80255c:	0f 85 ab 00 00 00    	jne    80260d <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802562:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802569:	00 00 
  80256b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80256f:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802571:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802575:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80257c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802580:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802582:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802586:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80258d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802591:	48 bb e5 16 80 00 00 	movabs $0x8016e5,%rbx
  802598:	00 00 00 
  80259b:	ff d3                	call   *%rbx
  80259d:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8025a1:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8025a5:	ff d3                	call   *%rbx
  8025a7:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8025ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025b1:	eb 4d                	jmp    802600 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8025b3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025b8:	4c 89 ee             	mov    %r13,%rsi
  8025bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c0:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  8025c7:	00 00 00 
  8025ca:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8025cc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025d1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025da:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8025e6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025eb:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f4:	48 b8 05 13 80 00 00 	movabs $0x801305,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	call   *%rax
}
  802600:	89 d8                	mov    %ebx,%eax
  802602:	48 83 c4 18          	add    $0x18,%rsp
  802606:	5b                   	pop    %rbx
  802607:	41 5c                	pop    %r12
  802609:	41 5d                	pop    %r13
  80260b:	5d                   	pop    %rbp
  80260c:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80260d:	48 b9 00 41 80 00 00 	movabs $0x804100,%rcx
  802614:	00 00 00 
  802617:	48 ba c1 43 80 00 00 	movabs $0x8043c1,%rdx
  80261e:	00 00 00 
  802621:	be 2e 00 00 00       	mov    $0x2e,%esi
  802626:	48 bf e8 43 80 00 00 	movabs $0x8043e8,%rdi
  80262d:	00 00 00 
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
  802635:	49 b8 4c 2c 80 00 00 	movabs $0x802c4c,%r8
  80263c:	00 00 00 
  80263f:	41 ff d0             	call   *%r8

0000000000802642 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802642:	f3 0f 1e fa          	endbr64
  802646:	55                   	push   %rbp
  802647:	48 89 e5             	mov    %rsp,%rbp
  80264a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80264e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802652:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  802659:	00 00 00 
  80265c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80265e:	85 c0                	test   %eax,%eax
  802660:	78 35                	js     802697 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802662:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802666:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  80266d:	00 00 00 
  802670:	ff d0                	call   *%rax
  802672:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802675:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80267a:	be 00 10 00 00       	mov    $0x1000,%esi
  80267f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802683:	48 b8 95 11 80 00 00 	movabs $0x801195,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	call   *%rax
  80268f:	85 c0                	test   %eax,%eax
  802691:	0f 94 c0             	sete   %al
  802694:	0f b6 c0             	movzbl %al,%eax
}
  802697:	c9                   	leave
  802698:	c3                   	ret

0000000000802699 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802699:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80269d:	48 89 f8             	mov    %rdi,%rax
  8026a0:	48 c1 e8 27          	shr    $0x27,%rax
  8026a4:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8026ab:	7f 00 00 
  8026ae:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026b2:	f6 c2 01             	test   $0x1,%dl
  8026b5:	74 6d                	je     802724 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8026b7:	48 89 f8             	mov    %rdi,%rax
  8026ba:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026be:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8026c5:	7f 00 00 
  8026c8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026cc:	f6 c2 01             	test   $0x1,%dl
  8026cf:	74 62                	je     802733 <get_uvpt_entry+0x9a>
  8026d1:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8026d8:	7f 00 00 
  8026db:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026df:	f6 c2 80             	test   $0x80,%dl
  8026e2:	75 4f                	jne    802733 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8026e4:	48 89 f8             	mov    %rdi,%rax
  8026e7:	48 c1 e8 15          	shr    $0x15,%rax
  8026eb:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8026f2:	7f 00 00 
  8026f5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026f9:	f6 c2 01             	test   $0x1,%dl
  8026fc:	74 44                	je     802742 <get_uvpt_entry+0xa9>
  8026fe:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802705:	7f 00 00 
  802708:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80270c:	f6 c2 80             	test   $0x80,%dl
  80270f:	75 31                	jne    802742 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802711:	48 c1 ef 0c          	shr    $0xc,%rdi
  802715:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80271c:	7f 00 00 
  80271f:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802723:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802724:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80272b:	7f 00 00 
  80272e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802732:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802733:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80273a:	7f 00 00 
  80273d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802741:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802742:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802749:	7f 00 00 
  80274c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802750:	c3                   	ret

0000000000802751 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802751:	f3 0f 1e fa          	endbr64
  802755:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802758:	48 89 f9             	mov    %rdi,%rcx
  80275b:	48 c1 e9 27          	shr    $0x27,%rcx
  80275f:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802766:	7f 00 00 
  802769:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80276d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802774:	f6 c1 01             	test   $0x1,%cl
  802777:	0f 84 b2 00 00 00    	je     80282f <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80277d:	48 89 f9             	mov    %rdi,%rcx
  802780:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802784:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80278b:	7f 00 00 
  80278e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802792:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802799:	40 f6 c6 01          	test   $0x1,%sil
  80279d:	0f 84 8c 00 00 00    	je     80282f <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8027a3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8027aa:	7f 00 00 
  8027ad:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027b1:	a8 80                	test   $0x80,%al
  8027b3:	75 7b                	jne    802830 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8027b5:	48 89 f9             	mov    %rdi,%rcx
  8027b8:	48 c1 e9 15          	shr    $0x15,%rcx
  8027bc:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8027c3:	7f 00 00 
  8027c6:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8027ca:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8027d1:	40 f6 c6 01          	test   $0x1,%sil
  8027d5:	74 58                	je     80282f <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8027d7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8027de:	7f 00 00 
  8027e1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027e5:	a8 80                	test   $0x80,%al
  8027e7:	75 6c                	jne    802855 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8027e9:	48 89 f9             	mov    %rdi,%rcx
  8027ec:	48 c1 e9 0c          	shr    $0xc,%rcx
  8027f0:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8027f7:	7f 00 00 
  8027fa:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8027fe:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802805:	40 f6 c6 01          	test   $0x1,%sil
  802809:	74 24                	je     80282f <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80280b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802812:	7f 00 00 
  802815:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802819:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802820:	ff ff 7f 
  802823:	48 21 c8             	and    %rcx,%rax
  802826:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80282c:	48 09 d0             	or     %rdx,%rax
}
  80282f:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802830:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802837:	7f 00 00 
  80283a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80283e:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802845:	ff ff 7f 
  802848:	48 21 c8             	and    %rcx,%rax
  80284b:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802851:	48 01 d0             	add    %rdx,%rax
  802854:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802855:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80285c:	7f 00 00 
  80285f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802863:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80286a:	ff ff 7f 
  80286d:	48 21 c8             	and    %rcx,%rax
  802870:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802876:	48 01 d0             	add    %rdx,%rax
  802879:	c3                   	ret

000000000080287a <get_prot>:

int
get_prot(void *va) {
  80287a:	f3 0f 1e fa          	endbr64
  80287e:	55                   	push   %rbp
  80287f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802882:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  802889:	00 00 00 
  80288c:	ff d0                	call   *%rax
  80288e:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802891:	83 e0 01             	and    $0x1,%eax
  802894:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802897:	89 d1                	mov    %edx,%ecx
  802899:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  80289f:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8028a1:	89 c1                	mov    %eax,%ecx
  8028a3:	83 c9 02             	or     $0x2,%ecx
  8028a6:	f6 c2 02             	test   $0x2,%dl
  8028a9:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8028ac:	89 c1                	mov    %eax,%ecx
  8028ae:	83 c9 01             	or     $0x1,%ecx
  8028b1:	48 85 d2             	test   %rdx,%rdx
  8028b4:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8028b7:	89 c1                	mov    %eax,%ecx
  8028b9:	83 c9 40             	or     $0x40,%ecx
  8028bc:	f6 c6 04             	test   $0x4,%dh
  8028bf:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8028c2:	5d                   	pop    %rbp
  8028c3:	c3                   	ret

00000000008028c4 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8028c4:	f3 0f 1e fa          	endbr64
  8028c8:	55                   	push   %rbp
  8028c9:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028cc:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  8028d3:	00 00 00 
  8028d6:	ff d0                	call   *%rax
    return pte & PTE_D;
  8028d8:	48 c1 e8 06          	shr    $0x6,%rax
  8028dc:	83 e0 01             	and    $0x1,%eax
}
  8028df:	5d                   	pop    %rbp
  8028e0:	c3                   	ret

00000000008028e1 <is_page_present>:

bool
is_page_present(void *va) {
  8028e1:	f3 0f 1e fa          	endbr64
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028e9:	48 b8 99 26 80 00 00 	movabs $0x802699,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	call   *%rax
  8028f5:	83 e0 01             	and    $0x1,%eax
}
  8028f8:	5d                   	pop    %rbp
  8028f9:	c3                   	ret

00000000008028fa <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028fa:	f3 0f 1e fa          	endbr64
  8028fe:	55                   	push   %rbp
  8028ff:	48 89 e5             	mov    %rsp,%rbp
  802902:	41 57                	push   %r15
  802904:	41 56                	push   %r14
  802906:	41 55                	push   %r13
  802908:	41 54                	push   %r12
  80290a:	53                   	push   %rbx
  80290b:	48 83 ec 18          	sub    $0x18,%rsp
  80290f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802913:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802917:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80291c:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802923:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802926:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80292d:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802930:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802937:	00 00 00 
  80293a:	eb 73                	jmp    8029af <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80293c:	48 89 d8             	mov    %rbx,%rax
  80293f:	48 c1 e8 15          	shr    $0x15,%rax
  802943:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  80294a:	7f 00 00 
  80294d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802951:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802957:	f6 c2 01             	test   $0x1,%dl
  80295a:	74 4b                	je     8029a7 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80295c:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802960:	f6 c2 80             	test   $0x80,%dl
  802963:	74 11                	je     802976 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802965:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802969:	f6 c4 04             	test   $0x4,%ah
  80296c:	74 39                	je     8029a7 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80296e:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802974:	eb 20                	jmp    802996 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802976:	48 89 da             	mov    %rbx,%rdx
  802979:	48 c1 ea 0c          	shr    $0xc,%rdx
  80297d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802984:	7f 00 00 
  802987:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80298b:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802991:	f6 c4 04             	test   $0x4,%ah
  802994:	74 11                	je     8029a7 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802996:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80299a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80299e:	48 89 df             	mov    %rbx,%rdi
  8029a1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029a5:	ff d0                	call   *%rax
    next:
        va += size;
  8029a7:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8029aa:	49 39 df             	cmp    %rbx,%r15
  8029ad:	72 3e                	jb     8029ed <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8029af:	49 8b 06             	mov    (%r14),%rax
  8029b2:	a8 01                	test   $0x1,%al
  8029b4:	74 37                	je     8029ed <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8029b6:	48 89 d8             	mov    %rbx,%rax
  8029b9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029bd:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8029c2:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8029c8:	f6 c2 01             	test   $0x1,%dl
  8029cb:	74 da                	je     8029a7 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8029cd:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8029d2:	f6 c2 80             	test   $0x80,%dl
  8029d5:	0f 84 61 ff ff ff    	je     80293c <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8029db:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8029e0:	f6 c4 04             	test   $0x4,%ah
  8029e3:	74 c2                	je     8029a7 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8029e5:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8029eb:	eb a9                	jmp    802996 <foreach_shared_region+0x9c>
    }
    return res;
}
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	48 83 c4 18          	add    $0x18,%rsp
  8029f6:	5b                   	pop    %rbx
  8029f7:	41 5c                	pop    %r12
  8029f9:	41 5d                	pop    %r13
  8029fb:	41 5e                	pop    %r14
  8029fd:	41 5f                	pop    %r15
  8029ff:	5d                   	pop    %rbp
  802a00:	c3                   	ret

0000000000802a01 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802a01:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0a:	c3                   	ret

0000000000802a0b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802a0b:	f3 0f 1e fa          	endbr64
  802a0f:	55                   	push   %rbp
  802a10:	48 89 e5             	mov    %rsp,%rbp
  802a13:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802a16:	48 be f8 43 80 00 00 	movabs $0x8043f8,%rsi
  802a1d:	00 00 00 
  802a20:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	call   *%rax
    return 0;
}
  802a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a31:	5d                   	pop    %rbp
  802a32:	c3                   	ret

0000000000802a33 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802a33:	f3 0f 1e fa          	endbr64
  802a37:	55                   	push   %rbp
  802a38:	48 89 e5             	mov    %rsp,%rbp
  802a3b:	41 57                	push   %r15
  802a3d:	41 56                	push   %r14
  802a3f:	41 55                	push   %r13
  802a41:	41 54                	push   %r12
  802a43:	53                   	push   %rbx
  802a44:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a4b:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a52:	48 85 d2             	test   %rdx,%rdx
  802a55:	74 7a                	je     802ad1 <devcons_write+0x9e>
  802a57:	49 89 d6             	mov    %rdx,%r14
  802a5a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a60:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802a65:	49 bf db 0d 80 00 00 	movabs $0x800ddb,%r15
  802a6c:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a6f:	4c 89 f3             	mov    %r14,%rbx
  802a72:	48 29 f3             	sub    %rsi,%rbx
  802a75:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a7a:	48 39 c3             	cmp    %rax,%rbx
  802a7d:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a81:	4c 63 eb             	movslq %ebx,%r13
  802a84:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802a8b:	48 01 c6             	add    %rax,%rsi
  802a8e:	4c 89 ea             	mov    %r13,%rdx
  802a91:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a98:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a9b:	4c 89 ee             	mov    %r13,%rsi
  802a9e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802aa5:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802ab1:	41 01 dc             	add    %ebx,%r12d
  802ab4:	49 63 f4             	movslq %r12d,%rsi
  802ab7:	4c 39 f6             	cmp    %r14,%rsi
  802aba:	72 b3                	jb     802a6f <devcons_write+0x3c>
    return res;
  802abc:	49 63 c4             	movslq %r12d,%rax
}
  802abf:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802ac6:	5b                   	pop    %rbx
  802ac7:	41 5c                	pop    %r12
  802ac9:	41 5d                	pop    %r13
  802acb:	41 5e                	pop    %r14
  802acd:	41 5f                	pop    %r15
  802acf:	5d                   	pop    %rbp
  802ad0:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802ad1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ad7:	eb e3                	jmp    802abc <devcons_write+0x89>

0000000000802ad9 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802ad9:	f3 0f 1e fa          	endbr64
  802add:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae5:	48 85 c0             	test   %rax,%rax
  802ae8:	74 55                	je     802b3f <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802aea:	55                   	push   %rbp
  802aeb:	48 89 e5             	mov    %rsp,%rbp
  802aee:	41 55                	push   %r13
  802af0:	41 54                	push   %r12
  802af2:	53                   	push   %rbx
  802af3:	48 83 ec 08          	sub    $0x8,%rsp
  802af7:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802afa:	48 bb 51 10 80 00 00 	movabs $0x801051,%rbx
  802b01:	00 00 00 
  802b04:	49 bc 2a 11 80 00 00 	movabs $0x80112a,%r12
  802b0b:	00 00 00 
  802b0e:	eb 03                	jmp    802b13 <devcons_read+0x3a>
  802b10:	41 ff d4             	call   *%r12
  802b13:	ff d3                	call   *%rbx
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 f7                	je     802b10 <devcons_read+0x37>
    if (c < 0) return c;
  802b19:	48 63 d0             	movslq %eax,%rdx
  802b1c:	78 13                	js     802b31 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  802b23:	83 f8 04             	cmp    $0x4,%eax
  802b26:	74 09                	je     802b31 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802b28:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802b2c:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802b31:	48 89 d0             	mov    %rdx,%rax
  802b34:	48 83 c4 08          	add    $0x8,%rsp
  802b38:	5b                   	pop    %rbx
  802b39:	41 5c                	pop    %r12
  802b3b:	41 5d                	pop    %r13
  802b3d:	5d                   	pop    %rbp
  802b3e:	c3                   	ret
  802b3f:	48 89 d0             	mov    %rdx,%rax
  802b42:	c3                   	ret

0000000000802b43 <cputchar>:
cputchar(int ch) {
  802b43:	f3 0f 1e fa          	endbr64
  802b47:	55                   	push   %rbp
  802b48:	48 89 e5             	mov    %rsp,%rbp
  802b4b:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b4f:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b53:	be 01 00 00 00       	mov    $0x1,%esi
  802b58:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802b5c:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  802b63:	00 00 00 
  802b66:	ff d0                	call   *%rax
}
  802b68:	c9                   	leave
  802b69:	c3                   	ret

0000000000802b6a <getchar>:
getchar(void) {
  802b6a:	f3 0f 1e fa          	endbr64
  802b6e:	55                   	push   %rbp
  802b6f:	48 89 e5             	mov    %rsp,%rbp
  802b72:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b76:	ba 01 00 00 00       	mov    $0x1,%edx
  802b7b:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b84:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	call   *%rax
  802b90:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b92:	85 c0                	test   %eax,%eax
  802b94:	78 06                	js     802b9c <getchar+0x32>
  802b96:	74 08                	je     802ba0 <getchar+0x36>
  802b98:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b9c:	89 d0                	mov    %edx,%eax
  802b9e:	c9                   	leave
  802b9f:	c3                   	ret
    return res < 0 ? res : res ? c :
  802ba0:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802ba5:	eb f5                	jmp    802b9c <getchar+0x32>

0000000000802ba7 <iscons>:
iscons(int fdnum) {
  802ba7:	f3 0f 1e fa          	endbr64
  802bab:	55                   	push   %rbp
  802bac:	48 89 e5             	mov    %rsp,%rbp
  802baf:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802bb3:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802bb7:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  802bbe:	00 00 00 
  802bc1:	ff d0                	call   *%rax
    if (res < 0) return res;
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	78 18                	js     802bdf <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802bc7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bcb:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802bd2:	00 00 00 
  802bd5:	8b 00                	mov    (%rax),%eax
  802bd7:	39 02                	cmp    %eax,(%rdx)
  802bd9:	0f 94 c0             	sete   %al
  802bdc:	0f b6 c0             	movzbl %al,%eax
}
  802bdf:	c9                   	leave
  802be0:	c3                   	ret

0000000000802be1 <opencons>:
opencons(void) {
  802be1:	f3 0f 1e fa          	endbr64
  802be5:	55                   	push   %rbp
  802be6:	48 89 e5             	mov    %rsp,%rbp
  802be9:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802bed:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802bf1:	48 b8 1b 17 80 00 00 	movabs $0x80171b,%rax
  802bf8:	00 00 00 
  802bfb:	ff d0                	call   *%rax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	78 49                	js     802c4a <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802c01:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c06:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c0b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c14:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	call   *%rax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	78 26                	js     802c4a <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802c24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c28:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802c2f:	00 00 
  802c31:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802c33:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c37:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802c3e:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	call   *%rax
}
  802c4a:	c9                   	leave
  802c4b:	c3                   	ret

0000000000802c4c <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802c4c:	f3 0f 1e fa          	endbr64
  802c50:	55                   	push   %rbp
  802c51:	48 89 e5             	mov    %rsp,%rbp
  802c54:	41 56                	push   %r14
  802c56:	41 55                	push   %r13
  802c58:	41 54                	push   %r12
  802c5a:	53                   	push   %rbx
  802c5b:	48 83 ec 50          	sub    $0x50,%rsp
  802c5f:	49 89 fc             	mov    %rdi,%r12
  802c62:	41 89 f5             	mov    %esi,%r13d
  802c65:	48 89 d3             	mov    %rdx,%rbx
  802c68:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802c6c:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802c70:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802c74:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802c7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c7f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802c83:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802c87:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802c8b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802c92:	00 00 00 
  802c95:	4c 8b 30             	mov    (%rax),%r14
  802c98:	48 b8 f5 10 80 00 00 	movabs $0x8010f5,%rax
  802c9f:	00 00 00 
  802ca2:	ff d0                	call   *%rax
  802ca4:	89 c6                	mov    %eax,%esi
  802ca6:	45 89 e8             	mov    %r13d,%r8d
  802ca9:	4c 89 e1             	mov    %r12,%rcx
  802cac:	4c 89 f2             	mov    %r14,%rdx
  802caf:	48 bf 28 41 80 00 00 	movabs $0x804128,%rdi
  802cb6:	00 00 00 
  802cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbe:	49 bc 77 02 80 00 00 	movabs $0x800277,%r12
  802cc5:	00 00 00 
  802cc8:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802ccb:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802ccf:	48 89 df             	mov    %rbx,%rdi
  802cd2:	48 b8 0f 02 80 00 00 	movabs $0x80020f,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	call   *%rax
    cprintf("\n");
  802cde:	48 bf 9c 41 80 00 00 	movabs $0x80419c,%rdi
  802ce5:	00 00 00 
  802ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ced:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802cf0:	cc                   	int3
  802cf1:	eb fd                	jmp    802cf0 <_panic+0xa4>

0000000000802cf3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802cf3:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802cf6:	48 b8 32 2f 80 00 00 	movabs $0x802f32,%rax
  802cfd:	00 00 00 
    call *%rax
  802d00:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802d02:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802d05:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802d0c:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802d0d:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802d14:	00 
    pushq %rbx
  802d15:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802d16:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802d1d:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802d20:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802d24:	4c 8b 3c 24          	mov    (%rsp),%r15
  802d28:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802d2d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802d32:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802d37:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802d3c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802d41:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802d46:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802d4b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802d50:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802d55:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802d5a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802d5f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802d64:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802d69:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802d6e:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802d72:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802d76:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802d77:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802d78:	c3                   	ret

0000000000802d79 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802d79:	f3 0f 1e fa          	endbr64
  802d7d:	55                   	push   %rbp
  802d7e:	48 89 e5             	mov    %rsp,%rbp
  802d81:	41 54                	push   %r12
  802d83:	53                   	push   %rbx
  802d84:	48 89 fb             	mov    %rdi,%rbx
  802d87:	48 89 f7             	mov    %rsi,%rdi
  802d8a:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802d8d:	48 85 f6             	test   %rsi,%rsi
  802d90:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d97:	00 00 00 
  802d9a:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802d9e:	be 00 10 00 00       	mov    $0x1000,%esi
  802da3:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	call   *%rax
    if (res < 0) {
  802daf:	85 c0                	test   %eax,%eax
  802db1:	78 45                	js     802df8 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802db3:	48 85 db             	test   %rbx,%rbx
  802db6:	74 12                	je     802dca <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802db8:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802dbf:	00 00 00 
  802dc2:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802dc8:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802dca:	4d 85 e4             	test   %r12,%r12
  802dcd:	74 14                	je     802de3 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802dcf:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802dd6:	00 00 00 
  802dd9:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802ddf:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802de3:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802dea:	00 00 00 
  802ded:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802df3:	5b                   	pop    %rbx
  802df4:	41 5c                	pop    %r12
  802df6:	5d                   	pop    %rbp
  802df7:	c3                   	ret
        if (from_env_store != NULL) {
  802df8:	48 85 db             	test   %rbx,%rbx
  802dfb:	74 06                	je     802e03 <ipc_recv+0x8a>
            *from_env_store = 0;
  802dfd:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802e03:	4d 85 e4             	test   %r12,%r12
  802e06:	74 eb                	je     802df3 <ipc_recv+0x7a>
            *perm_store = 0;
  802e08:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802e0f:	00 
  802e10:	eb e1                	jmp    802df3 <ipc_recv+0x7a>

0000000000802e12 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802e12:	f3 0f 1e fa          	endbr64
  802e16:	55                   	push   %rbp
  802e17:	48 89 e5             	mov    %rsp,%rbp
  802e1a:	41 57                	push   %r15
  802e1c:	41 56                	push   %r14
  802e1e:	41 55                	push   %r13
  802e20:	41 54                	push   %r12
  802e22:	53                   	push   %rbx
  802e23:	48 83 ec 18          	sub    $0x18,%rsp
  802e27:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802e2a:	48 89 d3             	mov    %rdx,%rbx
  802e2d:	49 89 cc             	mov    %rcx,%r12
  802e30:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e33:	48 85 d2             	test   %rdx,%rdx
  802e36:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e3d:	00 00 00 
  802e40:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802e44:	89 f0                	mov    %esi,%eax
  802e46:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802e4a:	48 89 da             	mov    %rbx,%rdx
  802e4d:	48 89 c6             	mov    %rax,%rsi
  802e50:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	call   *%rax
    while (res < 0) {
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	79 65                	jns    802ec5 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802e60:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802e63:	75 33                	jne    802e98 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802e65:	49 bf 2a 11 80 00 00 	movabs $0x80112a,%r15
  802e6c:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802e6f:	49 be b7 14 80 00 00 	movabs $0x8014b7,%r14
  802e76:	00 00 00 
        sys_yield();
  802e79:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802e7c:	45 89 e8             	mov    %r13d,%r8d
  802e7f:	4c 89 e1             	mov    %r12,%rcx
  802e82:	48 89 da             	mov    %rbx,%rdx
  802e85:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802e89:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802e8c:	41 ff d6             	call   *%r14
    while (res < 0) {
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	79 32                	jns    802ec5 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802e93:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802e96:	74 e1                	je     802e79 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802e98:	89 c1                	mov    %eax,%ecx
  802e9a:	48 ba 04 44 80 00 00 	movabs $0x804404,%rdx
  802ea1:	00 00 00 
  802ea4:	be 42 00 00 00       	mov    $0x42,%esi
  802ea9:	48 bf 0f 44 80 00 00 	movabs $0x80440f,%rdi
  802eb0:	00 00 00 
  802eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb8:	49 b8 4c 2c 80 00 00 	movabs $0x802c4c,%r8
  802ebf:	00 00 00 
  802ec2:	41 ff d0             	call   *%r8
    }
}
  802ec5:	48 83 c4 18          	add    $0x18,%rsp
  802ec9:	5b                   	pop    %rbx
  802eca:	41 5c                	pop    %r12
  802ecc:	41 5d                	pop    %r13
  802ece:	41 5e                	pop    %r14
  802ed0:	41 5f                	pop    %r15
  802ed2:	5d                   	pop    %rbp
  802ed3:	c3                   	ret

0000000000802ed4 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802ed4:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802ed8:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802edd:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802ee4:	00 00 00 
  802ee7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802eeb:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802eef:	48 c1 e2 04          	shl    $0x4,%rdx
  802ef3:	48 01 ca             	add    %rcx,%rdx
  802ef6:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802efc:	39 fa                	cmp    %edi,%edx
  802efe:	74 12                	je     802f12 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802f00:	48 83 c0 01          	add    $0x1,%rax
  802f04:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802f0a:	75 db                	jne    802ee7 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f11:	c3                   	ret
            return envs[i].env_id;
  802f12:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f16:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f1a:	48 c1 e2 04          	shl    $0x4,%rdx
  802f1e:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802f25:	00 00 00 
  802f28:	48 01 d0             	add    %rdx,%rax
  802f2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f31:	c3                   	ret

0000000000802f32 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802f32:	f3 0f 1e fa          	endbr64
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	41 56                	push   %r14
  802f3c:	41 55                	push   %r13
  802f3e:	41 54                	push   %r12
  802f40:	53                   	push   %rbx
  802f41:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802f44:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802f4b:	00 00 00 
  802f4e:	48 83 38 00          	cmpq   $0x0,(%rax)
  802f52:	74 27                	je     802f7b <_handle_vectored_pagefault+0x49>
  802f54:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  802f59:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  802f60:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802f63:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  802f66:	4c 89 e7             	mov    %r12,%rdi
  802f69:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  802f6e:	84 c0                	test   %al,%al
  802f70:	75 45                	jne    802fb7 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802f72:	48 83 c3 01          	add    $0x1,%rbx
  802f76:	49 3b 1e             	cmp    (%r14),%rbx
  802f79:	72 eb                	jb     802f66 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  802f7b:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  802f82:	00 
  802f83:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  802f88:	4d 8b 04 24          	mov    (%r12),%r8
  802f8c:	48 ba 50 41 80 00 00 	movabs $0x804150,%rdx
  802f93:	00 00 00 
  802f96:	be 1d 00 00 00       	mov    $0x1d,%esi
  802f9b:	48 bf 19 44 80 00 00 	movabs $0x804419,%rdi
  802fa2:	00 00 00 
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802faa:	49 ba 4c 2c 80 00 00 	movabs $0x802c4c,%r10
  802fb1:	00 00 00 
  802fb4:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  802fb7:	5b                   	pop    %rbx
  802fb8:	41 5c                	pop    %r12
  802fba:	41 5d                	pop    %r13
  802fbc:	41 5e                	pop    %r14
  802fbe:	5d                   	pop    %rbp
  802fbf:	c3                   	ret

0000000000802fc0 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  802fc0:	f3 0f 1e fa          	endbr64
  802fc4:	55                   	push   %rbp
  802fc5:	48 89 e5             	mov    %rsp,%rbp
  802fc8:	53                   	push   %rbx
  802fc9:	48 83 ec 08          	sub    $0x8,%rsp
  802fcd:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  802fd0:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802fd7:	00 00 00 
  802fda:	80 38 00             	cmpb   $0x0,(%rax)
  802fdd:	0f 84 84 00 00 00    	je     803067 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  802fe3:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802fea:	00 00 00 
  802fed:	48 8b 10             	mov    (%rax),%rdx
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  802ff5:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  802ffc:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fff:	48 85 d2             	test   %rdx,%rdx
  803002:	74 19                	je     80301d <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803004:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803008:	0f 84 e8 00 00 00    	je     8030f6 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80300e:	48 83 c0 01          	add    $0x1,%rax
  803012:	48 39 d0             	cmp    %rdx,%rax
  803015:	75 ed                	jne    803004 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803017:	48 83 fa 08          	cmp    $0x8,%rdx
  80301b:	74 1c                	je     803039 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80301d:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803021:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803028:	00 00 00 
  80302b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803032:	00 00 00 
  803035:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803039:	48 b8 f5 10 80 00 00 	movabs $0x8010f5,%rax
  803040:	00 00 00 
  803043:	ff d0                	call   *%rax
  803045:	89 c7                	mov    %eax,%edi
  803047:	48 be f3 2c 80 00 00 	movabs $0x802cf3,%rsi
  80304e:	00 00 00 
  803051:	48 b8 4a 14 80 00 00 	movabs $0x80144a,%rax
  803058:	00 00 00 
  80305b:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80305d:	85 c0                	test   %eax,%eax
  80305f:	78 68                	js     8030c9 <add_pgfault_handler+0x109>
    return res;
}
  803061:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803065:	c9                   	leave
  803066:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803067:	48 b8 f5 10 80 00 00 	movabs $0x8010f5,%rax
  80306e:	00 00 00 
  803071:	ff d0                	call   *%rax
  803073:	89 c7                	mov    %eax,%edi
  803075:	b9 06 00 00 00       	mov    $0x6,%ecx
  80307a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80307f:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803086:	00 00 00 
  803089:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  803090:	00 00 00 
  803093:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803095:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  80309c:	00 00 00 
  80309f:	48 8b 02             	mov    (%rdx),%rax
  8030a2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8030a6:	48 89 0a             	mov    %rcx,(%rdx)
  8030a9:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8030b0:	00 00 00 
  8030b3:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8030b7:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8030be:	00 00 00 
  8030c1:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  8030c4:	e9 70 ff ff ff       	jmp    803039 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8030c9:	89 c1                	mov    %eax,%ecx
  8030cb:	48 ba 27 44 80 00 00 	movabs $0x804427,%rdx
  8030d2:	00 00 00 
  8030d5:	be 3d 00 00 00       	mov    $0x3d,%esi
  8030da:	48 bf 19 44 80 00 00 	movabs $0x804419,%rdi
  8030e1:	00 00 00 
  8030e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e9:	49 b8 4c 2c 80 00 00 	movabs $0x802c4c,%r8
  8030f0:	00 00 00 
  8030f3:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8030f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fb:	e9 61 ff ff ff       	jmp    803061 <add_pgfault_handler+0xa1>

0000000000803100 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803100:	f3 0f 1e fa          	endbr64
  803104:	55                   	push   %rbp
  803105:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803108:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80310f:	00 00 00 
  803112:	80 38 00             	cmpb   $0x0,(%rax)
  803115:	74 33                	je     80314a <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803117:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  80311e:	00 00 00 
  803121:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803126:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80312d:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803130:	48 85 c0             	test   %rax,%rax
  803133:	0f 84 85 00 00 00    	je     8031be <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  803139:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  80313d:	74 40                	je     80317f <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80313f:	48 83 c1 01          	add    $0x1,%rcx
  803143:	48 39 c1             	cmp    %rax,%rcx
  803146:	75 f1                	jne    803139 <remove_pgfault_handler+0x39>
  803148:	eb 74                	jmp    8031be <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  80314a:	48 b9 3f 44 80 00 00 	movabs $0x80443f,%rcx
  803151:	00 00 00 
  803154:	48 ba c1 43 80 00 00 	movabs $0x8043c1,%rdx
  80315b:	00 00 00 
  80315e:	be 43 00 00 00       	mov    $0x43,%esi
  803163:	48 bf 19 44 80 00 00 	movabs $0x804419,%rdi
  80316a:	00 00 00 
  80316d:	b8 00 00 00 00       	mov    $0x0,%eax
  803172:	49 b8 4c 2c 80 00 00 	movabs $0x802c4c,%r8
  803179:	00 00 00 
  80317c:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80317f:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803186:	00 
  803187:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80318b:	48 29 ca             	sub    %rcx,%rdx
  80318e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803195:	00 00 00 
  803198:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  80319c:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  8031a1:	48 89 ce             	mov    %rcx,%rsi
  8031a4:	48 b8 db 0d 80 00 00 	movabs $0x800ddb,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	call   *%rax
            _pfhandler_off--;
  8031b0:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8031b7:	00 00 00 
  8031ba:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  8031be:	5d                   	pop    %rbp
  8031bf:	c3                   	ret

00000000008031c0 <__text_end>:
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
